import SwiftUI

struct SkillEditView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: SkillViewModel
    @State private var title: String
    @State private var description: String
    @State private var level: Int
    @State private var resources: [Resource]
    @State private var showingResourceSheet = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    init(skill: Skill? = nil) {
        _viewModel = StateObject(wrappedValue: SkillViewModel())
        _title = State(initialValue: skill?.title ?? "")
        _description = State(initialValue: skill?.description ?? "")
        _level = State(initialValue: skill?.level ?? 1)
        _resources = State(initialValue: skill?.resources ?? [])
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("基本信息")) {
                    TextField("技能名称", text: $title)
                    TextEditor(text: $description)
                        .frame(height: 100)
                }
                
                Section(header: Text("技能等级")) {
                    Stepper("等级: \(level)", value: $level, in: 1...5)
                }
                
                Section(header: Text("学习资源")) {
                    ForEach(resources) { resource in
                        ResourceRowView(resource: resource)
                    }
                    .onDelete { indexSet in
                        resources.remove(atOffsets: indexSet)
                    }
                    
                    Button(action: {
                        showingResourceSheet = true
                    }) {
                        Label("添加资源", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("编辑技能")
            .navigationBarItems(
                leading: Button("取消") {
                    dismiss()
                },
                trailing: Button("保存") {
                    saveSkill()
                }
            )
            .sheet(isPresented: $showingResourceSheet) {
                ResourceEditView()
            }
            .alert("提示", isPresented: $showingAlert) {
                Button("确定", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func saveSkill() {
        guard !title.isEmpty else {
            alertMessage = "请输入技能名称"
            showingAlert = true
            return
        }
        
        let skill = Skill(
            id: UUID().uuidString,
            title: title,
            description: description,
            level: level,
            resources: resources,
            createdAt: Date()
        )
        
        Task {
            do {
                try await viewModel.saveSkill(skill)
                dismiss()
            } catch {
                alertMessage = "保存失败：\(error.localizedDescription)"
                showingAlert = true
            }
        }
    }
}

#Preview {
    SkillEditView()
} 