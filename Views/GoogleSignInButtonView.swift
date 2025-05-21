// 完整 GoogleSignInButtonView.swift 修正版本

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

struct GoogleSignInButtonView: View {
    @StateObject private var authManager = AuthManager.shared
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        Button(action: signInWithGoogle) {
            HStack {
                Image("google_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                
                Text("使用 Google 账号登录")
                    .font(.headline)
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 2)
        }
        .alert("提示", isPresented: $showingAlert) {
            Button("确定", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak authManager] result, error in
            if let error = error {
                alertMessage = "登录失败：\(error.localizedDescription)"
                showingAlert = true
                return
            }
            
            guard let authentication = result?.user,
                  let idToken = authentication.idToken?.tokenString else {
                alertMessage = "登录失败：无法获取用户信息"
                showingAlert = true
                return
            }
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: authentication.accessToken.tokenString
            )
            
            Task {
                do {
                    try await authManager?.signInWithGoogle(credential: credential)
                } catch {
                    alertMessage = "登录失败：\(error.localizedDescription)"
                    showingAlert = true
                }
            }
        }
    }
}

#Preview {
    GoogleSignInButtonView()
}
