 
 
import SwiftUI


@main
struct SkillRoadApp: App {
       // 注册 AppDelegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
