//
//  AuthRepository.swift
//  RecordNote
//
//  Created by Mohamed Ali on 27/05/2026.
//

import UIKit
import GoogleSignInSwift
import GoogleSignIn

final class AuthRepository: AuthRepositoryProtocol {
    private let service: AuthAPI
    private let local: LocalStorageProtocol = LocalStorage()
    
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
    
}
