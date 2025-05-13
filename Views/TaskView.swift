import SwiftUI

struct TaskView: View {
    @State private var showAddTask = false
    @State private var tasks: [TaskModel] = []

    var body: some View {
        NavigationView {
            List {
                ForEach(tasks) { task in
                    HStack {
                        Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                            .onTapGesture {
                                FirebaseTaskService.shared.toggleTask(task)
                            }
                        VStack(alignment: .leading) {
                            Text(task.title).font(.headline)
                            if let dueDate = task.dueDate {
                                Text("截止: \(dueDate.formatted(date: .abbreviated, time: .omitted))")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        Spacer()
                        Button(role: .destructive) {
                            FirebaseTaskService.shared.deleteTask(task.id)
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }
            }
            .navigationTitle("任务清单")
            .toolbar {
                Button(action: { showAddTask = true }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showAddTask) {
                AddTaskSheet()
            }
            .onAppear {
                FirebaseTaskService.shared.fetchTasks { fetched in
                    tasks = fetched
                }
            }
        }
    }
}