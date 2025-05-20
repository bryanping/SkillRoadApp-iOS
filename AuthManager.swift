import Foundation
import FirebaseAuth
import GoogleSignIn

@MainActor
class AuthManager: ObservableObject {
    static let shared = AuthManager()
    
    @Published var user: User?
    @Published var isAuthenticated = false
    
    private init() {
        setupAuthStateListener()
    }
    
    private func setupAuthStateListener() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.user = user
            self?.isAuthenticated = user != nil
        }
    }
    
    func signInWithGoogle(credential: AuthCredential) async throws {
        let result = try await Auth.auth().signIn(with: credential)
        user = result.user
        isAuthenticated = true
    }
    
    func signInWithApple(idToken: String, nonce: String) async throws {
        let credential = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: idToken,
            rawNonce: nonce
        )
        
        let result = try await Auth.auth().signIn(with: credential)
        user = result.user
        isAuthenticated = true
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
        user = nil
        isAuthenticated = false
    }
    
    func deleteAccount() async throws {
        guard let user = user else { return }
        try await user.delete()
        self.user = nil
        isAuthenticated = false
    }
}