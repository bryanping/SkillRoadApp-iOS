import Foundation
import FirebaseFirestore

@MainActor
class ResourceViewModel: ObservableObject {
    @Published var resources: [Resource] = []
    private let db = Firestore.firestore()
    
    func saveResource(_ resource: Resource) async throws {
        let data: [String: Any] = [
            "id": resource.id,
            "title": resource.title,
            "description": resource.description,
            "type": resource.type.rawValue,
            "url": resource.url,
            "createdAt": resource.createdAt
        ]
        
        try await db.collection("resources").document(resource.id).setData(data)
    }
    
    func fetchResources() async throws {
        let snapshot = try await db.collection("resources").getDocuments()
        resources = snapshot.documents.compactMap { document in
            let data = document.data()
            guard let id = data["id"] as? String,
                  let title = data["title"] as? String,
                  let description = data["description"] as? String,
                  let typeString = data["type"] as? String,
                  let type = ResourceType(rawValue: typeString),
                  let url = data["url"] as? String,
                  let createdAt = (data["createdAt"] as? Timestamp)?.dateValue() else {
                return nil
            }
            
            return Resource(
                id: id,
                title: title,
                description: description,
                type: type,
                url: url,
                createdAt: createdAt
            )
        }
    }
    
    func deleteResource(_ resource: Resource) async throws {
        try await db.collection("resources").document(resource.id).delete()
        resources.removeAll { $0.id == resource.id }
    }
} 