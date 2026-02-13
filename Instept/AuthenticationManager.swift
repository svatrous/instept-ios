import Foundation
import AuthenticationServices
import FirebaseAuth
import CryptoKit
import Combine

class AuthenticationManager: ObservableObject {
    var currentNonce: String?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func prepareRequest(_ request: ASAuthorizationAppleIDRequest) {
        let nonce = CryptoUtils.randomNonceString()
        currentNonce = nonce
        request.requestedScopes = [.fullName, .email]
        request.nonce = CryptoUtils.sha256(nonce)
    }
    
    func handleAuthorization(_ authorization: ASAuthorization, completion: @escaping () -> Void) {
        isLoading = true
        errorMessage = nil
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                self.errorMessage = "Unable to fetch identity token"
                self.isLoading = false
                return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                self.errorMessage = "Unable to serialize token string"
                self.isLoading = false
                return
            }
            
            // Authenticate with Firebase
            // Use instance method if static is unavailable in newer SDK
            
            let credential = OAuthProvider.credential(providerID: .apple, idToken: idTokenString, rawNonce: nonce)
            
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print("Error authenticating: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                    return
                }
                
                // User is signed in
                print("User is signed in with Firebase. UID: \(authResult?.user.uid ?? "")")
                
                // Update display name if provided
                if let fullName = appleIDCredential.fullName {
                    let givenName = fullName.givenName ?? ""
                    let familyName = fullName.familyName ?? ""
                    let displayName = "\(givenName) \(familyName)".trimmingCharacters(in: .whitespaces)
                    
                    if !displayName.isEmpty {
                        let changeRequest = authResult?.user.createProfileChangeRequest()
                        changeRequest?.displayName = displayName
                        changeRequest?.commitChanges { error in
                            if let error = error {
                                print("Error updating profile: \(error.localizedDescription)")
                            }
                        }
                    }
                }
                
                self.isLoading = false
                UserManager.shared.fetchSavedRecipes()
                completion()
            }
        }
    }
    
    func handleError(_ error: Error) {
        print("Sign in with Apple errored: \(error.localizedDescription)")
        self.errorMessage = error.localizedDescription
        self.isLoading = false
    }
}
