import Foundation
import FirebaseAuth
import GoogleSignIn

@MainActor
class AuthManager: ObservableObject {
    static let shared = AuthManager()
    
    @Published var user: User?
    @Published var isAuthenticated = false
    @Published var error: Error?
    
    private init() {
        setupAuthStateListener()
    }
    
    private func setupAuthStateListener() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            self.user = user
            self.isAuthenticated = user != nil
        }
    }
    
    func signInWithGoogle(credential: AuthCredential) async throws {
        do {
            let result = try await Auth.auth().signIn(with: credential)
            self.user = result.user
            self.isAuthenticated = true
        } catch {
            self.error = error
            throw error
        }
    }
    
    func signInWithApple(idToken: String, nonce: String) async throws {
        do {
            let credential = OAuthProvider.credential(
                withProviderID: "apple.com",
                idToken: idToken,
                rawNonce: nonce
            )
            
            let result = try await Auth.auth().signIn(with: credential)
            self.user = result.user
            self.isAuthenticated = true
        } catch {
            self.error = error
            throw error
        }
    }
    
    func signOut() async throws {
        do {
            try await Auth.auth().signOut()
            self.user = nil
            self.isAuthenticated = false
        } catch {
            self.error = error
            throw error
        }
    }
    
    func deleteAccount() async throws {
        guard let user = user else {
            throw NSError(domain: "AuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user is currently signed in"])
        }
        
        do {
            try await user.delete()
            self.user = nil
            self.isAuthenticated = false
        } catch {
            self.error = error
            throw error
        }
    }
    
    func clearError() {
        self.error = nil
    }
}