import Foundation

// 技能难度等级
enum SkillLevel: String, Codable, CaseIterable {
    case beginner = "初级"
    case intermediate = "中级"
    case advanced = "高级"
    case expert = "专家"
    
    var level: Int {
        switch self {
        case .beginner: return 1
        case .intermediate: return 2
        case .advanced: return 3
        case .expert: return 4
        }
    }
}

// 技能状态
enum SkillStatus: String, Codable, CaseIterable {
    case notStarted = "未开始"
    case inProgress = "进行中"
    case completed = "已完成"
    case onHold = "暂停"
}

// 技能分类
enum SkillCategory: String, Codable, CaseIterable {
    case programming = "编程"
    case design = "设计"
    case business = "商业"
    case language = "语言"
    case other = "其他"
}

struct Skill: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let level: SkillLevel
    var status: SkillStatus
    let category: SkillCategory
    var resources: [Resource]
    let createdAt: Date
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: createdAt)
    }
    
    var levelDescription: String {
        level.rawValue
    }

    init(
        id: String = UUID().uuidString,
        title: String,
        description: String,
        level: SkillLevel,
        status: SkillStatus = .notStarted,
        category: SkillCategory,
        resources: [Resource] = [],
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.level = level
        self.status = status
        self.category = category
        self.resources = resources
        self.createdAt = createdAt
    }
}