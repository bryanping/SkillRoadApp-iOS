import SwiftUI
import Foundation
import Combine


struct HomeView: View {
    @ObservedObject var dataManager = DataManager.shared
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    SectionTitle(title: "技能象限图")
                    RoundedBox(text: "象限图 Placeholder", color: .teal)

                    SectionTitle(title: "日历")
                    RoundedBox(text: "日历简易显示", color: .blue)

                    SectionTitle(title:"今日待办事项")
                    ForEach(1...3, id: \.self) { index in
                        TaskCard(index: index)
                    }

                    SectionTitle(title:"技能进度")
                    if dataManager.skills.isEmpty {
                        Text("暂无技能，请添加技能...")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(dataManager.skills) { skill in
                            SkillProgressView(skill: skill)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("SkillRoad")
        }
    }
}

struct SectionTitle: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.headline)
            .padding(.vertical, 4)
    }
}

struct RoundedBox: View {
    let text: String
    let color: Color
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(color.opacity(0.2))
            .frame(height: 100)
            .overlay(Text(text))
    }
}

struct TaskCard: View {
    let index: Int
    var body: some View {
        HStack {
            Image(systemName: "checkmark.square")
            VStack(alignment: .leading) {
                Text("任务 \(index)")
                Text("任务详情...")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

struct SkillProgressView: View {
    let skill: Skill
    var body: some View {
        VStack(alignment: .leading) {
            Text(skill.name).fontWeight(.medium)
            ProgressView(value: skill.progress)
                .accentColor(.teal)
            Text("进度: \(Int(skill.progress * 100))%")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 4)
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let mockSkills = [
            Skill(name: "Swift 基础", description: "学习 Swift 语言基础", category: .programming, level: .beginner, status: .inProgress, progress: 0.3, estimatedHours: 10, actualHours: 2),
            Skill(name: "UI 设计", description: "掌握基本 UI 设计原则", category: .design, level: .intermediate, status: .notStarted, progress: 0.0, estimatedHours: 8, actualHours: 0),
            Skill(name: "项目管理", description: "学习敏捷开发流程", category: .business, level: .advanced, status: .completed, progress: 1.0, estimatedHours: 12, actualHours: 12)
        ]
        let previewManager = DataManager.shared
        previewManager.skills = mockSkills
        return HomeView(dataManager: previewManager)
    }
}
#endif
