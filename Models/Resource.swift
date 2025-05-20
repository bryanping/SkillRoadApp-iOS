//
//  Resource.swift
//  SkillRoadApp
//
//  Created by 林平 on 2025/5/13.
//

import Foundation

enum ResourceType: String, CaseIterable, Codable {
    case link = "链接"
    case image = "图片"
    case file = "文件"
}

struct Resource: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let type: ResourceType
    let url: String
    let createdAt: Date
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: createdAt)
    }
}
