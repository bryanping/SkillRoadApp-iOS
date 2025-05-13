import SwiftUI

struct SkillDetailView: View {
    let skill: Skill

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(skill.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                ProgressView(value: skill.progress)
                    .accentColor(.green)

                Text("技能介绍")
                    .font(.title2)
                    .padding(.top)

                Text(skill.description)

                Text("关联任务")
                    .font(.title3)
                    .padding(.top)

                ForEach(skill.relatedTasks, id: \.self) { task in
                    Label(task, systemImage: "checkmark.seal")
                        .padding(.vertical, 2)
                }
            }
            .padding()
        }
        .navigationTitle("技能详情")
        .navigationBarTitleDisplayMode(.inline)
    }
}
