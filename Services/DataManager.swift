import Foundation
import Combine

// 导入 Skill 模型


class DataManager: ObservableObject {
    // 单例模式
    static let shared = DataManager()
    
    // 发布技能列表变化
    @Published private(set) var skills: [Skill] = []
    
    // 文件管理器
    private let fileManager = FileManager.default
    
    // 数据文件URL
    private var dataFileURL: URL {
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsDirectory.appendingPathComponent("skills.json")
    }
    
    private init() {
        loadSkills()
    }
    
    // MARK: - 数据加载
    func loadSkills() {
        do {
            if fileManager.fileExists(atPath: dataFileURL.path) {
                let data = try Data(contentsOf: dataFileURL)
                skills = try JSONDecoder().decode([Skill].self, from: data)
            }
        } catch {
            print("加载技能数据失败: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 数据保存
    private func saveSkills() {
        do {
            let data = try JSONEncoder().encode(skills)
            try data.write(to: dataFileURL)
        } catch {
            print("保存技能数据失败: \(error.localizedDescription)")
        }
    }
    
    // MARK: - CRUD 操作
    
    // 添加新技能
    func addSkill(_ skill: Skill) {
        skills.append(skill)
        saveSkills()
    }
    
    // 更新技能
    func updateSkill(_ skill: Skill) {
        if let index = skills.firstIndex(where: { $0.id == skill.id }) {
            skills[index] = skill
            saveSkills()
        }
    }
    
    // 删除技能
    func deleteSkill(_ skill: Skill) {
        skills.removeAll { $0.id == skill.id }
        saveSkills()
    }
    
    // 获取技能
    func getSkill(by id: UUID) -> Skill? {
        return skills.first { $0.id == id }
    }
    
    // 获取所有技能
    func getAllSkills() -> [Skill] {
        return skills
    }
    
    // 按类别获取技能
    func getSkills(by category: SkillCategory) -> [Skill] {
        return skills.filter { $0.category == category }
    }
    
    // 按状态获取技能
    func getSkills(by status: SkillStatus) -> [Skill] {
        return skills.filter { $0.status == status }
    }
    
    // 更新技能进度
    func updateSkillProgress(id: UUID, progress: Double) {
        if let index = skills.firstIndex(where: { $0.id == id }) {
            var skill = skills[index]
            skill.progress = progress
            skill.status = progress >= 1.0 ? .completed : .inProgress
            skill.updatedAt = Date()
            skills[index] = skill
            saveSkills()
        }
    }
    
    // 添加学习资源
    func addResource(to skillId: UUID, resource: Resource) {
        if let index = skills.firstIndex(where: { $0.id == skillId }) {
            var skill = skills[index]
            skill.resources.append(resource)
            skill.updatedAt = Date()
            skills[index] = skill
            saveSkills()
        }
    }
    
    // 更新学习资源状态
    func updateResourceStatus(skillId: UUID, resourceId: UUID, isCompleted: Bool) {
        if let skillIndex = skills.firstIndex(where: { $0.id == skillId }),
           let resourceIndex = skills[skillIndex].resources.firstIndex(where: { $0.id == resourceId }) {
            var skill = skills[skillIndex]
            var resource = skill.resources[resourceIndex]
            resource.isCompleted = isCompleted
            skill.resources[resourceIndex] = resource
            skill.updatedAt = Date()
            skills[skillIndex] = skill
            saveSkills()
        }
    }
    
    // 获取技能树
    func getSkillTree() -> [Skill] {
        // 只返回顶级技能（没有前置技能的技能）
        return skills.filter { $0.prerequisites.isEmpty }
    }
    
    // 获取子技能
    func getSubSkills(for skillId: UUID) -> [Skill] {
        return skills.filter { $0.prerequisites.contains(skillId) }
    }
    
    // 搜索技能
    func searchSkills(query: String) -> [Skill] {
        let lowercasedQuery = query.lowercased()
        return skills.filter {
            $0.name.lowercased().contains(lowercasedQuery) ||
            $0.description.lowercased().contains(lowercasedQuery)
        }
    }
} 
