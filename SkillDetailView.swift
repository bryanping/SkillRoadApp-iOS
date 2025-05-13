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

                Text("学习资源")
                    .font(.title3)
                    .padding(.top)

                if skill.resources.isEmpty {
                    Text("暂无学习资源")
                        .foregroundColor(.gray)
                } else {
                    ForEach(skill.resources) { resource in
                        HStack {
                            Image(systemName: "book")
                            VStack(alignment: .leading) {
                                Text(resource.title)
                                    .fontWeight(.medium)
                                Text(resource.type.rawValue)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 2)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("技能详情")
        .navigationBarTitleDisplayMode(.inline)
    }
}
