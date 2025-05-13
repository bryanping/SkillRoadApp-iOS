import Foundation
import FirebaseFirestore
import FirebaseAuth

class FirebaseTaskService: ObservableObject {
    static let shared = FirebaseTaskService()
    private init() {}

    private var db = Firestore.firestore()

    func fetchTasks(completion: @escaping ([TaskModel]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        db.collection("users").document(uid).collection("tasks")
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("❌ 获取任务失败：\(error?.localizedDescription ?? "")")
                    return
                }

                let tasks = documents.compactMap { doc -> TaskModel? in
                    let data = doc.data()
                    let id = doc.documentID
                    let title = data["title"] as? String ?? ""
                    let category = data["category"] as? String ?? "Learning"
                    let isDone = data["isDone"] as? Bool ?? false
                    let timestamp = data["dueDate"] as? Timestamp
                    let dueDate = timestamp?.dateValue()
                    return TaskModel(id: id, title: title, category: category, isDone: isDone, dueDate: dueDate)
                }

                completion(tasks)
            }
    }

    func addTask(_ task: TaskModel) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        db.collection("users").document(uid).collection("tasks").document(task.id).setData([
            "title": task.title,
            "category": task.category,
            "isDone": task.isDone,
            "dueDate": task.dueDate ?? FieldValue.serverTimestamp(),
            "createdAt": FieldValue.serverTimestamp()
        ])
    }

    func toggleTask(_ task: TaskModel) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        db.collection("users").document(uid).collection("tasks").document(task.id).updateData([
            "isDone": !task.isDone
        ])
    }

    func deleteTask(_ taskID: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        db.collection("users").document(uid).collection("tasks").document(taskID).delete()
    }
}