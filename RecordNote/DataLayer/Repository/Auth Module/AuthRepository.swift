//
//  AuthRepository.swift
//  RecordNote
//
//  Created by Mohamed Ali on 27/05/2026.
//

import Foundation

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
}
