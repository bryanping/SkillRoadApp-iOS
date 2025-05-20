//
//  SkillViewModel.swift
//  SkillRoadApp
//
//  Created by 林平 on 2025/5/13.
//


import Foundation
import Combine
import FirebaseFirestore

@MainActor
class SkillViewModel: ObservableObject {
    @Published var skills: [Skill] = []
    private let db = Firestore.firestore()

    init() {
        // 初始化時可以載入預設技能資料
        loadSampleSkills()
    }

    func loadSampleSkills() {
        // 示例：新增一個預設技能
        let sampleSkill = Skill(
            title: "Swift 開發",
            description: "學習 Swift 語言的基礎知識",
           
            level: .beginner,
            status: .notStarted,
           
            estimatedHours: 10,
            actualHours: 0,
            prerequisites: [],
            resources: [],
            createdAt: Date(),
            updatedAt: Date(),
            dueDate: nil,
            notes: nil,
            subSkills: nil
        )
        skills.append(sampleSkill)
    }

    func saveSkill(_ skill: Skill) async throws {
        let data: [String: Any] = [
            "id": skill.id,
            "title": skill.title,
            "description": skill.description,
            "level": skill.level,
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
        
        try await db.collection("skills").document(skill.id).setData(data)
    }
    
    func fetchSkills() async throws {
        let snapshot = try await db.collection("skills").getDocuments()
        skills = snapshot.documents.compactMap { document in
            let data = document.data()
            guard let id = data["id"] as? String,
                  let title = data["title"] as? String,
                  let description = data["description"] as? String,
                  let level = data["level"] as? Int,
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
                resources: resources,
                createdAt: createdAt
            )
        }
    }
    
    func deleteSkill(_ skill: Skill) async throws {
        try await db.collection("skills").document(skill.id).delete()
        skills.removeAll { $0.id == skill.id }
    }

    // 根據需要，您可以新增更多方法來操作技能資料
}
