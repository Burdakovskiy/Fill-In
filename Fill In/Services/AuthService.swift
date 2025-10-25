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

final class AuthService: NSObject {
    static let shared = AuthService()
    private override init() {}

    // MARK: - Email / Password
    func signInWith(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error { completion(.failure(error)); return }
            if let user = result?.user { completion(.success(user)) }
        }
    }

    func signUpWithEmail(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error { completion(.failure(error)); return }
            if let user = result?.user { completion(.success(user)) }
        }
    }

    // MARK: - Google Sign-In
    func signInWithGoogle(presenting viewController: UIViewController, completion: @escaping (Result<User, Error>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            print("❌ Firebase clientID not found")
            return
        }

        GIDSignIn.sharedInstance.signOut()
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)

        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
            if let error = error { completion(.failure(error)); return }

            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                completion(.failure(NSError(domain: "GoogleSignIn",
                                            code: -1,
                                            userInfo: [NSLocalizedDescriptionKey: "Missing auth data"])))
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error { completion(.failure(error)); return }
                if let user = authResult?.user {
                    completion(.success(user))
                } else {
                    completion(.failure(NSError(domain: "FirebaseAuth",
                                                code: -1,
                                                userInfo: [NSLocalizedDescriptionKey: "User not found"])))
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
            if let error = error { completion(.failure(error)); return }

            if result?.isCancelled == true {
                completion(.failure(NSError(domain: "FacebookLogin",
                                            code: -2,
                                            userInfo: [NSLocalizedDescriptionKey: "User cancelled login"])))
                return
            }

            guard let token = AccessToken.current?.tokenString else {
                completion(.failure(NSError(domain: "FacebookLogin",
                                            code: -3,
                                            userInfo: [NSLocalizedDescriptionKey: "No access token"])))
                return
            }

            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error { completion(.failure(error)); return }
                if let user = result?.user { completion(.success(user)) }
            }
        }
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
            self.appleCompletion?(.failure(NSError(domain: "AppleSignIn",
                                                   code: -1,
                                                   userInfo: [NSLocalizedDescriptionKey: "Invalid Apple credential"])))
            return
        }

        let credential = OAuthProvider.appleCredential(
            withIDToken: tokenString,
            rawNonce: rawNonce,
            fullName: appleIDCredential.fullName
        )

        Auth.auth().signIn(with: credential) { result, error in
            if let error = error {
                self.appleCompletion?(.failure(error))
            } else if let user = result?.user {
                self.appleCompletion?(.success(user))
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithError error: Error) {
        self.appleCompletion?(.failure(error))
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

// MARK: - Presentation Context Provider

protocol AppleSignInPresentable: ASAuthorizationControllerPresentationContextProviding {}

extension AppleSignInPresentable where Self: UIViewController {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}
