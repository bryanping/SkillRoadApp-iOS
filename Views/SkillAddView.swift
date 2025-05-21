//
//  SkillAddView.swift
//  SkillRoadApp
//
//  Created by 林平 on 2025/5/13.
//

import SwiftUI

struct SkillAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var dataManager = DataManager.shared

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var level: SkillLevel = .beginner
    @State private var progress: Double = 0.0
    @State private var estimatedHours: Int = 0
    @State private var actualHours: Int = 0
    @State private var prerequisites: [UUID] = []
    @State private var notes: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("基本資料")) {
                    TextField("技能名稱", text: $name)
                    TextField("技能描述", text: $description)
                    Picker("難度", selection: $level) {
                        ForEach(SkillLevel.allCases, id: \.self) { l in
                            Text(l.rawValue).tag(l)
                        }
                    }
                }

                Section(header: Text("進度與時長")) {
                    Slider(value: $progress, in: 0...1)
                    Text("目前進度：\(Int(progress * 100))%")

                    Stepper("預估時數：\(estimatedHours) 小時", value: $estimatedHours, in: 0...100)
                    Stepper("實際時數：\(actualHours) 小時", value: $actualHours, in: 0...100)
                }

                Section(header: Text("前置技能")) {
                    ForEach(dataManager.skills) { skill in
                        Toggle(skill.name, isOn: Binding(
                            get: { prerequisites.contains(skill.id) },
                            set: { selected in
                                if selected {
                                    prerequisites.append(skill.id)
                                } else {
                                    prerequisites.removeAll { $0 == skill.id }
                                }
                            }
                        ))
                    }
                }

                Section(header: Text("備註")) {
                    TextEditor(text: $notes)
                        .frame(minHeight: 80)
                }
            }
            .navigationTitle("新增技能")
            .navigationBarItems(
                leading: Button("取消") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("儲存") {
                    let newSkill = Skill(
                        title: title,
                        description: description,
                        level: level,
                        status: progress >= 1.0 ? .completed : .inProgress,
                        progress: progress,
                        estimatedHours: estimatedHours,
                        actualHours: actualHours,
                        prerequisites: prerequisites,
                        resources: [],
                        createdAt: Date(),
                        updatedAt: Date(),
                        dueDate: nil,
                        notes: notes.isEmpty ? nil : notes,
                        subSkills: nil
                    )

                    dataManager.addSkill(newSkill)
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(name.isEmpty || description.isEmpty)
            )
        }
    }
}
