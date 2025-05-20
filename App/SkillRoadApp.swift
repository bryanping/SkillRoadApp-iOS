import SwiftUI
import FirebaseCore

@main
struct SkillRoadApp: App {
    @StateObject private var authManager = AuthManager.shared
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            LaunchScreenView()
                .environmentObject(authManager)
        }
    }
} 