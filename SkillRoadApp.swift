import SwiftUI
import FirebaseCore

@main
struct SkillRoadApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
