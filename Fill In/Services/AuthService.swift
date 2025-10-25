//
//  AuthService.swift
//  Fill In
//
//  Created by Дмитрий on 24.10.2025.
//

import FirebaseAuth
import GoogleSignIn
import AuthenticationServices
import FBSDKLoginKit
import UIKit
import FirebaseCore
import CryptoKit

//MARK: - AuthService
final class AuthService: NSObject {
    
    //MARK: - Singleton
    static let shared = AuthService()
    private override init() {}
    
    //MARK: - Public Properties
    var currentUser: User? {
        Auth.auth().currentUser
    }
    
    // MARK: - Email / Password
    func signInWith(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if let error {
                    completion(.failure(error))
                    return
                }
                guard let user = result?.user else {
                    completion(.failure(AuthError.userNotFound))
                    return
                }
                completion(.success(user))
            }
        }
    }
    
    func signUpWithEmail(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if let error {
                    completion(.failure(error))
                    return
                }
                guard let user = result?.user else {
                    completion(.failure(AuthError.userNotFound))
                    return
                }
                completion(.success(user))
            }
        }
    }
    
    // MARK: - Google Sign-In
    func signInWithGoogle(presenting viewController: UIViewController, completion: @escaping (Result<User, Error>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(.failure(AuthError.missingClientID))
            return
        }
        
        GIDSignIn.sharedInstance.signOut()
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
            if let error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                DispatchQueue.main.async { completion(.failure(AuthError.missingAuthData)) }
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                DispatchQueue.main.async {
                    if let error {
                        completion(.failure(error))
                        return
                    }
                    guard let user = authResult?.user else {
                        completion(.failure(AuthError.userNotFound))
                        return
                    }
                    completion(.success(user))
                }
            }
        }
    }
    
    // MARK: - Apple Sign-In
    private var currentNonce: String?
    private var appleCompletion: ((Result<User, Error>) -> Void)?
    
    func signInWithApple(presenting vc: UIViewController,
                         completion: @escaping (Result<User, Error>) -> Void) {
        appleCompletion = completion
        
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.email, .fullName]
        
        let nonce = Self.randomNonceString()
        currentNonce = nonce
        request.nonce = Self.sha256(nonce)
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        
        if let provider = vc as? AppleSignInPresentable {
            controller.presentationContextProvider = provider
        } else {
            assertionFailure("ViewController must conform to AppleSignInPresentable to handle Apple Sign In")
        }
        
        controller.performRequests()
    }
    
    // MARK: - Facebook Sign-In
    func signInWithFacebook(from viewController: UIViewController, completion: @escaping (Result<User, Error>) -> Void) {
        let manager = LoginManager()
        manager.logIn(permissions: ["email"], from: viewController) { result, error in
            if let error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            
            guard let result, !result.isCancelled else {
                DispatchQueue.main.async { completion(.failure(AuthError.cancelled)) }
                return
            }
            
            guard let token = AccessToken.current?.tokenString else {
                DispatchQueue.main.async { completion(.failure(AuthError.missingAuthData)) }
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            Auth.auth().signIn(with: credential) { result, error in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    guard let user = result?.user else {
                        completion(.failure(AuthError.userNotFound))
                        return
                    }
                    completion(.success(user))
                }
            }
        }
    }
    
    //MARK: - Logout
    func signOut() throws {
        try Auth.auth().signOut()
        GIDSignIn.sharedInstance.signOut()
        LoginManager().logOut()
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension AuthService: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let tokenData = appleIDCredential.identityToken,
              let tokenString = String(data: tokenData, encoding: .utf8),
              let rawNonce = currentNonce
        else {
            self.appleCompletion?(.failure(AuthError.invalidCredential))
            return
        }
        
        let credential = OAuthProvider.appleCredential(
            withIDToken: tokenString,
            rawNonce: rawNonce,
            fullName: appleIDCredential.fullName
        )
        
        Auth.auth().signIn(with: credential) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.appleCompletion?(.failure(error))
                    return
                }
                guard let user = result?.user else {
                    self.appleCompletion?(.failure(AuthError.userNotFound))
                    return
                }
                self.appleCompletion?(.success(user))
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithError error: Error) {
        DispatchQueue.main.async {
            self.appleCompletion?(.failure(error))
        }
    }
}

// MARK: - Nonce helpers
private extension AuthService {
    
    static func sha256(_ input: String) -> String {
        let data = Data(input.utf8)
        let hashed = SHA256.hash(data: data)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    static func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remaining = length
        
        while remaining > 0 {
            var random: UInt8 = 0
            let status = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if status != errSecSuccess { fatalError("Unable to generate nonce.") }
            if random < charset.count {
                result.append(charset[Int(random) % charset.count])
                remaining -= 1
            }
        }
        return result
    }
}

// MARK: - Protocol for Apple Sign-In Presentation
protocol AppleSignInPresentable: ASAuthorizationControllerPresentationContextProviding {}

extension AppleSignInPresentable where Self: UIViewController {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

// MARK: - Auth Errors
enum AuthError: LocalizedError {
    case userNotFound
    case missingClientID
    case missingAuthData
    case invalidCredential
    case cancelled
    
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "User not found."
        case .missingClientID:
            return "Firebase client ID is missing."
        case .missingAuthData:
            return "Missing authentication data."
        case .invalidCredential:
            return "Invalid Apple credential."
        case .cancelled:
            return "Login process was cancelled."
        }
    }
}
