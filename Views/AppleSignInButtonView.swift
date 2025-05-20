import SwiftUI
import AuthenticationServices
import Foundation
import FirebaseCore

struct AppleSignInButtonView: View {
    @StateObject private var authManager = AuthManager.shared
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        SignInWithAppleButton(
            .signIn,
            onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            },
            onCompletion: { result in
                switch result {
                case .success(let authResults):
                    if let credential = authResults.credential as? ASAuthorizationAppleIDCredential {
                        Task {
                            do {
                                try await AppleAuthService.shared.handleAuthorization(credential: credential)
                            } catch {
                                alertMessage = "登录失败：\(error.localizedDescription)"
                                showingAlert = true
                            }
                        }
                    }
                case .failure(let error):
                    alertMessage = "登录失败：\(error.localizedDescription)"
                    showingAlert = true
                }
            }
        )
        .frame(height: 50)
        .signInWithAppleButtonStyle(.black)
        .cornerRadius(8)
        .alert("提示", isPresented: $showingAlert) {
            Button("确定", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
}

#Preview {
    AppleSignInButtonView()
}
