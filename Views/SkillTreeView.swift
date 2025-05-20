import SwiftUI
import Combine
import Foundation

struct SkillTreeView: View {
    let skills: [Skill] = [
        Skill(name: "Swift 基础", description: "掌握变量、控制流与函数", category: .programming, level: .beginner, status: .inProgress, progress: 0.6, estimatedHours: 8, actualHours: 2),
        Skill(name: "UI 设计", description: "了解 SwiftUI 基本组件与布局", category: .design, level: .beginner, status: .inProgress, progress: 0.3, estimatedHours: 6, actualHours: 1)
    ]

    var body: some View {
        NavigationView {
            List(skills) { skill in
                NavigationLink(destination: SkillDetailView(skill: skill)) {
                    VStack(alignment: .leading) {
                        Text(skill.name).font(.headline)
                        ProgressView(value: skill.progress)
                            .accentColor(.blue)
                        Text(skill.description)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("技能树")
        }
    }
}

struct SkillEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var dataManager = DataManager.shared

    @State var skill: Skill
    var isNew: Bool

    var allSkills: [Skill] { dataManager.skills.filter { $0.id != skill.id } }

    var body: some View {
        Form {
            Section(header: {
                Text("基本信息")
            }) {
                TextField("技能名称", text: $skill.name)
                TextField("描述", text: $skill.description)
                Picker("类别", selection: $skill.category) {
                    ForEach(SkillCategory.allCases, id: \.self) { cat in
                        Text(cat.rawValue).tag(cat)
                    }
                }
                Picker("难度", selection: $skill.level) {
                    ForEach(SkillLevel.allCases, id: \.self) { lvl in
                        Text(lvl.rawValue).tag(lvl)
                    }
                }
            }

            Section(header: {
                Text("进度与时间")
            }) {
                Slider(value: $skill.progress, in: 0...1)
                Stepper("预计时长：\(skill.estimatedHours) 小时", value: $skill.estimatedHours, in: 0...100)
                Stepper("实际时长：\(skill.actualHours) 小时", value: $skill.actualHours, in: 0...100)
            }

            Section(header: {
                Text("前置技能")
            }) {
                ForEach(allSkills) { s in
                    Toggle(s.name, isOn: Binding(
                        get: { skill.prerequisites.contains(s.id) },
                        set: { checked in
                            if checked {
                                skill.prerequisites.append(s.id)
                            } else {
                                skill.prerequisites.removeAll { $0 == s.id }
                            }
                        }
                    ))
                }
            }

            Section(header: {
                Text("备注")
            }) {
                TextEditor(text: Binding($skill.notes, replacingNilWith: "")) // 修改內容
            }
        }
        .navigationTitle(isNew ? "新增技能" : "编辑技能")
        .navigationBarItems(
            leading: Button("取消") { presentationMode.wrappedValue.dismiss() },
            trailing: Button("保存") {
                if isNew {
                    dataManager.addSkill(skill) // 修改內容
                } else {
                    dataManager.updateSkill(skill)
                }
                presentationMode.wrappedValue.dismiss()
            }
        )
    }
}

// 輔助：綁定 Optional String
extension Binding where Value == String? {
    init(_ source: Binding<String?>, replacingNilWith defaultValue: String) {
        self.init(
            get: { source.wrappedValue ?? defaultValue },
            set: { source.wrappedValue = $0 }
        )
    }
}

struct ResourceEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var resource: Resource
    var onSave: (Resource) -> Void

    var body: some View {
        Form {
            TextField("标题", text: $resource.title)
            Picker("类型", selection: $resource.type) {
                ForEach(ResourceType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            TextField("链接", text: Binding(
                get: { resource.url?.absoluteString ?? "" },
                set: { resource.url = URL(string: $0) }
            ))
            TextField("描述", text: $resource.description)
            Toggle("已完成", isOn: $resource.isCompleted)
        }
        .navigationTitle("编辑资源")
        .navigationBarItems(
            leading: Button("取消") { presentationMode.wrappedValue.dismiss() },
            trailing: Button("保存") {
                onSave(resource)
                presentationMode.wrappedValue.dismiss()
            }
        )
    }
}
