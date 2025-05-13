import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("首页", systemImage: "house")
                }

            SkillTreeView()
                .tabItem {
                    Label("技能树", systemImage: "chart.bar.xaxis")
                }

            TaskView()
                .tabItem {
                    Label("任务", systemImage: "checkmark.circle")
                }

            SettingsView()
                .tabItem {  
                    Label("设定", systemImage: "gear")
                }
        }
    }
}

// MARK: - Previews
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
