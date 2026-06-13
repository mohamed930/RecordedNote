//
//  AuthRepository.swift
//  RecordNote
//
//  Created by Mohamed Ali on 27/05/2026.
//

import UIKit
import GoogleSignInSwift
import GoogleSignIn
import AuthenticationServices

final class AuthRepository: NSObject , AuthRepositoryProtocol {
    
    private let service: AuthAPI
    private let local: LocalStorageProtocol = LocalStorage()
    private var continuation: CheckedContinuation<AppleUserEntity, Error>?
    
    init(service: AuthAPI) {
        self.service = service
    }
    
    func login(email: String, password: String) async throws -> Bool {
        let response = try await service.login(data: UserInputModel(signType: .email,
                                                                    phoneNumber: nil,
                                                                    email: email,
                                                                    password: password))
        
        if response.success {
            guard let data = response.data else { return false }
            
            local.write(key: LocalStorageKeys.firstTime, value: data.partnerToken)
            local.write(key: LocalStorageKeys.fullName, value: data.name)
            local.write(key: LocalStorageKeys.email, value: data.mail)
            
            return true
        }
        else {
            return false
        }
    }
    
    func loginWithGoogle(email: String, token: String) async throws -> Bool {
        let response = try await service.login(data: UserInputModel(name: "",
                                                                    signType: .email,
                                                                    email: email,
                                                                    firebaseToken: token))
        
        if response.success {
            guard let data = response.data else { return false }
            
            local.write(key: LocalStorageKeys.firstTime, value: data.partnerToken)
            local.write(key: LocalStorageKeys.fullName, value: data.name)
            
            return true
        }
        else {
            return false
        }
    }
    
    
    func signup(fullName: String, email: String, password: String) async throws -> String {
        let response = try await service.signUp(params: UserInputModel(name: fullName,
                                                                       signType: .email,
                                                                       email: email,
                                                                       password: password,
                                                                       firebaseToken: ""))
        if response.success {
            guard let data = response.data else { return "Unknown error" }
            
            local.write(key: LocalStorageKeys.firstTime, value: data.partnerToken)
            
            return ""
        }
        else {
            return response.message ?? "Unknown error"
        }
    }
    
    func signupWithGoogle(fullName: String, email: String, token: String) async throws -> String {
        let response = try await service.signUp(params: UserInputModel(name: fullName,
                                                                       signType: .email,
                                                                       email: email,
                                                                       firebaseToken: token))
        if response.success {
            guard let data = response.data else { return "Unknown error" }
            
            local.write(key: LocalStorageKeys.firstTime, value: data.partnerToken)
            
            return ""
        }
        else {
            return response.message ?? "Unknown error"
        }
    }
    
    
    func loginWithGoogle() async throws -> Bool {
        do {
            let googleUser = try await openGoogleSignIn()
            
            let response = try await loginWithGoogle(email: googleUser.email, token: googleUser.idToken)
            
            return response
            
        } catch {
            print(error.localizedDescription)
            
            return false
        }
    }
    
    func signupWithGoogle() async throws -> Bool {
        do {
            let googleUser = try await openGoogleSignIn()
            
            let response = try await signupWithGoogle(fullName: googleUser.name, email: googleUser.email, token: googleUser.idToken)
            
            return response.isEmpty
            
        } catch {
            print(error.localizedDescription)
            
            return false
        }
    }
    
    func singInWtihApple() async throws -> Bool {
        do {
            let appleUssr = try await checkAppleAuth()
            
            var email: String = ""
            
            if let appleEmail = appleUssr.email, !appleEmail.isEmpty {
                email = appleEmail
            }
            else {
                if let savedEmail: String = local.value(key: LocalStorageKeys.appleEmail) {
                    email = savedEmail
                }
                else {
                    return false
                }
            }
            
            let response = try await loginWithGoogle(email: email, token: appleUssr.identityToken)
            
            return response
            
        } catch {
            print(error.localizedDescription)
            
            return false
        }
    }
    
    func singOutWtihApple() async throws -> Bool {
        do {
            let appleUssr = try await checkAppleAuth()
            
            if let email = appleUssr.email, !email.isEmpty {
                local.write(key: LocalStorageKeys.appleEmail, value: email)
            }
            
            let response = try await signupWithGoogle(fullName: "\(appleUssr.firstName ?? "") \(appleUssr.lastName ?? "")", email: appleUssr.email ?? "", token: appleUssr.identityToken)
            
            return response.isEmpty
            
        } catch {
            print(error.localizedDescription)
            
            return false
        }
    }
}

extension AuthRepository {
    
    private func openGoogleSignIn() async throws -> GoogleUserEntity {
        
        guard let rootVC = UIApplication.shared
            .connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?
            .keyWindow?
            .rootViewController else {
            throw APIError.unknown
        }

        let result = try await GIDSignIn.sharedInstance.signIn(
            withPresenting: rootVC
        )

        let user = result.user
        
        return GoogleUserEntity(
            email: user.profile?.email ?? "",
            name: user.profile?.name ?? "",
            idToken: user.idToken?.tokenString ?? ""
        )
    }
    
    private func checkAppleAuth() async throws -> AppleUserEntity {
        
        try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation

            let request = ASAuthorizationAppleIDProvider()
                .createRequest()

            request.requestedScopes = [
                .fullName,
                .email
            ]

            let controller = ASAuthorizationController(
                authorizationRequests: [request]
            )

            controller.delegate = self
            controller.presentationContextProvider = self

            controller.performRequests()
        }
    }
    
}

extension AuthRepository: ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding {

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {

        guard let credential =
                authorization.credential
                as? ASAuthorizationAppleIDCredential
        else {
            continuation?.resume(
                throwing: APIError.unknown
            )
            return
        }

        guard let tokenData = credential.identityToken,
              let token = String(
                data: tokenData,
                encoding: .utf8
              )
        else {
            continuation?.resume(
                throwing: APIError.unknown
            )
            return
        }

        let user = AppleUserEntity(
            userIdentifier: credential.user,
            email: credential.email,
            firstName: credential.fullName?.givenName,
            lastName: credential.fullName?.familyName,
            identityToken: token
        )

        continuation?.resume(
            returning: user
        )

        continuation = nil
    }

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {

        continuation?.resume(
            throwing: error
        )

        continuation = nil
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let window = windowScene.windows.first(where: \.isKeyWindow) else {

            return UIWindow()
        }

        return window
    }
}
