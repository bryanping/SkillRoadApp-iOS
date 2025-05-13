// 完整 AppleAuthService.swift 修正版本
import Foundation
import AuthenticationServices

class AppleAuthService: NSObject {
    static let shared = AppleAuthService()
    
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
}