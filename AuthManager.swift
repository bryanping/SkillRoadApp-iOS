import FirebaseAuth
import FirebaseCore
import SwiftUI

class AuthManager: ObservableObject {
    @Published var user: User?

    init() {
        self.user = Auth.auth().currentUser
        Auth.auth().addStateDidChangeListener { _, user in
            self.user = user
        }
    }

    func signInAnonymously() {
        Auth.auth().signInAnonymously { result, error in
            if let error = error {
                print("❌ 匿名登入失敗: \(error.localizedDescription)")
            } else {
                print("✅ 匿名登入成功")
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            print("✅ 登出成功")
        } catch {
            print("❌ 登出失敗: \(error.localizedDescription)")
        }
    }
}
