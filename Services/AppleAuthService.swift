// 完整 AppleAuthService.swift 修正版本
import Foundation
import AuthenticationServices
import FirebaseAuth
import CryptoKit

class AppleAuthService: NSObject {
    static let shared = AppleAuthService()
    private var currentNonce: String?
    
    private override init() {
        super.init()
    }
    
    // 处理 Apple 授权回调
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // 你可以在这里获取 user、email、fullName 等信息
            let userIdentifier = appleIDCredential.user
            let email = appleIDCredential.email
            let fullName = appleIDCredential.fullName
            print("Apple 登录成功，user: \(userIdentifier), email: \(email ?? "无"), name: \(fullName?.givenName ?? "无")")
            
            // TODO: 这里可以集成 Firebase Auth，或调用你的后端接口
        }
    }
    
    // 处理 Apple 授权失败
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple 登录失败: \(error.localizedDescription)")
    }
    
    func handleAuthorization(credential: ASAuthorizationAppleIDCredential) async throws {
        guard let nonce = currentNonce else {
            throw AuthError.invalidNonce
        }
        
        guard let appleIDToken = credential.identityToken,
              let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            throw AuthError.invalidToken
        }
        
        let firebaseCredential = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: idTokenString,
            rawNonce: nonce
        )
        
        try await AuthManager.shared.signInWithApple(idToken: idTokenString, nonce: nonce)
    }
    
    func generateNonce() -> String {
        let nonce = randomNonceString()
        currentNonce = nonce
        return nonce
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
}

enum AuthError: Error {
    case invalidNonce
    case invalidToken
    case signInFailed
}