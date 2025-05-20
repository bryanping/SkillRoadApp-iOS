import SwiftUI

struct SkillDetailView: View {
    @ObservedObject var dataManager = DataManager.shared
    @State var skill: Skill

    @State private var showingAddResource = false
    @State private var editingResource: Resource? = nil

    var body: some View {
        Form {
            Section(header: Text("基本信息")) {
                Text("名稱：\(skill.name)")
                Text("描述：\(skill.description)")
                Text("分類：\(skill.category.rawValue)")
                Text("難度：\(skill.level.rawValue)")
                Text("狀態：\(skill.status.rawValue)")
            }

            Section(header: Text("進度與時長")) {
                ProgressView(value: skill.progress)
                Text("進度：\(Int(skill.progress * 100))%")
                Text("預估時數：\(skill.estimatedHours)")
                Text("實際時數：\(skill.actualHours)")
            }

            Section(header: Text("備註")) {
                if let notes = skill.notes, !notes.isEmpty {
                    Text(notes)
                } else {
                    Text("無")
                        .foregroundColor(.gray)
                }
            }

            Section(header: Text("資源")) {
                if skill.resources.isEmpty {
                    Text("尚未添加任何學習資源")
                        .foregroundColor(.gray)
                } else {
                    ForEach(skill.resources) { resource in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(resource.title)
                                    .fontWeight(.medium)
                                Spacer()
                                if resource.isCompleted {
                                    Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                                } else {
                                    Image(systemName: "circle").foregroundColor(.gray)
                                }
                            }
                            Text(resource.description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            editingResource = resource
                        }
                    }
                }

                Button(action: {
                    showingAddResource = true
                }) {
                    Label("新增資源", systemImage: "plus")
                }
            }
        }
        .navigationTitle("技能詳情")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingAddResource) {
            NavigationView {
                ResourceEditView(
                    resource: Resource(title: "", type: .article, description: ""),
                    onSave: { newResource in
                        dataManager.addResource(to: skill.id, resource: newResource)
                        skill.resources.append(newResource)
                        showingAddResource = false
                    }
                )
            }
        }
        .sheet(item: $editingResource) { resource in
            NavigationView {
                ResourceEditView(resource: resource) { updated in
                    dataManager.updateResourceStatus(skillId: skill.id, resourceId: updated.id, isCompleted: updated.isCompleted)
                    if let index = skill.resources.firstIndex(where: { $0.id == updated.id }) {
                        skill.resources[index] = updated
                    }
                    editingResource = nil
                }
            }
        }
    }
}
