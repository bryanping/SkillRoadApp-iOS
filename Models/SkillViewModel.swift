import Foundation
import Combine
import FirebaseFirestore

@MainActor
class SkillViewModel: ObservableObject {
    @Published var skills: [Skill] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let db = Firestore.firestore()

    init() {
        Task {
            await loadSkills()
        }
    }

    func loadSampleSkills() {
        let sampleSkills = [
            Skill(
                title: "Swift 编程基础",
                description: "学习 Swift 语言的基础知识和核心概念",
                level: .beginner,
                category: .programming
            ),
            Skill(
                title: "UI/UX 设计入门",
                description: "了解用户界面和用户体验设计的基本原则",
                level: .beginner,
                category: .design
            )
        ]
        
        Task {
            do {
                for skill in sampleSkills {
                    try await saveSkill(skill)
                }
                await loadSkills()
            } catch {
                self.error = error
            }
        }
    }

    func saveSkill(_ skill: Skill) async throws {
        isLoading = true
        defer { isLoading = false }
        
        let data: [String: Any] = [
            "id": skill.id,
            "title": skill.title,
            "description": skill.description,
            "level": skill.level.rawValue,
            "status": skill.status.rawValue,
            "category": skill.category.rawValue,
            "resources": skill.resources.map { resource in
                [
                    "id": resource.id,
                    "title": resource.title,
                    "description": resource.description,
                    "type": resource.type.rawValue,
                    "url": resource.url,
                    "createdAt": resource.createdAt
                ]
            },
            "createdAt": skill.createdAt
        ]
        
        do {
            try await db.collection("skills").document(skill.id).setData(data)
            await loadSkills()
        } catch {
            self.error = error
            throw error
        }
    }
    
    func loadSkills() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let snapshot = try await db.collection("skills").getDocuments()
            skills = snapshot.documents.compactMap { document in
                let data = document.data()
                guard let id = data["id"] as? String,
                      let title = data["title"] as? String,
                      let description = data["description"] as? String,
                      let levelString = data["level"] as? String,
                      let level = SkillLevel(rawValue: levelString),
                      let statusString = data["status"] as? String,
                      let status = SkillStatus(rawValue: statusString),
                      let categoryString = data["category"] as? String,
                      let category = SkillCategory(rawValue: categoryString),
                      let resourcesData = data["resources"] as? [[String: Any]],
                      let createdAt = (data["createdAt"] as? Timestamp)?.dateValue() else {
                    return nil
                }
                
                let resources = resourcesData.compactMap { resourceData -> Resource? in
                    guard let id = resourceData["id"] as? String,
                          let title = resourceData["title"] as? String,
                          let description = resourceData["description"] as? String,
                          let typeString = resourceData["type"] as? String,
                          let type = ResourceType(rawValue: typeString),
                          let url = resourceData["url"] as? String,
                          let createdAt = (resourceData["createdAt"] as? Timestamp)?.dateValue() else {
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
                
                return Skill(
                    id: id,
                    title: title,
                    description: description,
                    level: level,
                    status: status,
                    category: category,
                    resources: resources,
                    createdAt: createdAt
                )
            }
        } catch {
            self.error = error
        }
    }
    
    func deleteSkill(_ skill: Skill) async throws {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await db.collection("skills").document(skill.id).delete()
            skills.removeAll { $0.id == skill.id }
        } catch {
            self.error = error
            throw error
        }
    }
    
    func clearError() {
        self.error = nil
    }
}