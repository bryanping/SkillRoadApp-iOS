import SwiftUI
import AuthenticationServices

struct AppleSignInButtonView: View {
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
                        AppleAuthService.shared.authorizationController(controller: ASAuthorizationController(authorizationRequests: []), didCompleteWithAuthorization: authResults)
                    }
                case .failure(let error):
                    print("❌ Apple Sign-In Failed: \(error.localizedDescription)")
                }
            }
        )
        .frame(height: 50)
        .signInWithAppleButtonStyle(.black)
        .cornerRadius(8)
    }
}