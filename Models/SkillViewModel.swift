//
//  SkillViewModel.swift
//  SkillRoadApp
//
//  Created by 林平 on 2025/5/13.
//


import Foundation
import Combine

class SkillViewModel: ObservableObject {
    @Published var skills: [Skill] = []

    init() {
        // 初始化時可以載入預設技能資料
        loadSampleSkills()
    }

    func loadSampleSkills() {
        // 示例：新增一個預設技能
        let sampleSkill = Skill(
            name: "Swift 開發",
            description: "學習 Swift 語言的基礎知識",
            category: .programming,
            level: .beginner,
            status: .notStarted,
            progress: 0.0,
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

    // 根據需要，您可以新增更多方法來操作技能資料
}
