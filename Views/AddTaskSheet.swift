import SwiftUI

struct AddTaskSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var title: String = ""
    @State private var category: String = "Learning"
    @State private var dueDate = Date()

    var body: some View {
        NavigationView {
            Form {
                TextField("任务名称", text: $title)
                Picker("分类", selection: $category) {
                    Text("学习").tag("Learning")
                    Text("练习").tag("Practice")
                    Text("测验").tag("Test")
                }
                DatePicker("截止时间", selection: $dueDate, displayedComponents: .date)
            }
            .navigationTitle("新增任务")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("新增") {
                        let task = TaskModel(title: title, category: category, dueDate: dueDate)
                        FirebaseTaskService.shared.addTask(task)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消", role: .cancel) {
                        dismiss()
                    }
                }
            }
        }
    }
}