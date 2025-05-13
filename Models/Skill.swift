import Foundation
import Combine

// 技能难度等级
enum SkillLevel: String, Codable {
    case beginner = "初级"
    case intermediate = "中级"
    case advanced = "高级"
    case expert = "专家"
}

// 技能状态
enum SkillStatus: String, Codable {
    case notStarted = "未开始"
    case inProgress = "进行中"
    case completed = "已完成"
    case onHold = "暂停"
}

// 技能分类
enum SkillCategory: String, Codable {
    case programming = "编程"
    case design = "设计"
    case business = "商业"
    case language = "语言"
    case other = "其他"
}

struct Skill: Identifiable, Codable {
    let id: UUID
    var name: String
    var description: String
    var category: SkillCategory
    var level: SkillLevel
    var status: SkillStatus
    var progress: Double // 0.0 到 1.0
    var estimatedHours: Int
    var actualHours: Int
    var prerequisites: [UUID] // 前置技能ID
    var resources: [Resource]
    var createdAt: Date
    var updatedAt: Date
    var dueDate: Date?
    var notes: String?
    
    // 子技能
    var subSkills: [Skill]?
    
    init(
        id: UUID = UUID(),
        name: String,
        description: String,
        category: SkillCategory = .other,
        level: SkillLevel = .beginner,
        status: SkillStatus = .notStarted,
        progress: Double = 0.0,
        estimatedHours: Int = 0,
        actualHours: Int = 0,
        prerequisites: [UUID] = [],
        resources: [Resource] = [],
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        dueDate: Date? = nil,
        notes: String? = nil,
        subSkills: [Skill]? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.category = category
        self.level = level
        self.status = status
        self.progress = progress
        self.estimatedHours = estimatedHours
        self.actualHours = actualHours
        self.prerequisites = prerequisites
        self.resources = resources
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.dueDate = dueDate
        self.notes = notes
        self.subSkills = subSkills
    }
}

// 学习资源模型
struct Resource: Identifiable, Codable {
    let id: UUID
    var title: String
    var type: ResourceType
    var url: URL?
    var description: String
    var isCompleted: Bool
    
    init(
        id: UUID = UUID(),
        title: String,
        type: ResourceType,
        url: URL? = nil,
        description: String,
        isCompleted: Bool = false
    ) {
        self.id = id
        self.title = title
        self.type = type
        self.url = url
        self.description = description
        self.isCompleted = isCompleted
    }
}

// 资源类型
enum ResourceType: String, Codable {
    case video = "视频"
    case article = "文章"
    case book = "书籍"
    case course = "课程"
    case project = "项目"
    case other = "其他"
} 