import Foundation

struct TaskModel: Identifiable, Codable {
    let id: String
    var title: String
    var category: String
    var isDone: Bool
    var dueDate: Date?

    init(id: String = UUID().uuidString, title: String, category: String = "Learning", isDone: Bool = false, dueDate: Date? = nil) {
        self.id = id
        self.title = title
        self.category = category
        self.isDone = isDone
        self.dueDate = dueDate
    }
}