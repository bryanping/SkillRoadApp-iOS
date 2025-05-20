// HomeView.swift

import SwiftUI

struct HomeView: View {
    @ObservedObject var dataManager = DataManager.shared
    @State private var showingAddSkill = false  // 控制新增技能彈窗顯示

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    SectionTitle(title: "技能象限图")
                    RoundedBox(text: "象限图 Placeholder", color: .teal)

                    SectionTitle(title: "日历")
                    RoundedBox(text: "日历简易显示", color: .blue)

                    SectionTitle(title: "今日待办事项")
                    ForEach(1...3, id: \.self) { index in
                        TaskCard(index: index)
                    }

                    SectionTitle(title: "技能进度")
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
            .navigationBarItems(trailing: Button(action: {
                showingAddSkill = true
            }) {
                Image(systemName: "plus")
            })
        }
        // 當 sheet 關閉時，自動刷新技能列表
        .sheet(isPresented: $showingAddSkill, onDismiss: {
            dataManager.loadSkills()
        }) {
            SkillAddView()
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
                Text("任務 \(index)")
                Text("任務詳情...")
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
            Text("進度: \(Int(skill.progress * 100))%")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 4)
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
#endif
