//
//  AuthRepository.swift
//  RecordNote
//
//  Created by Mohamed Ali on 27/05/2026.
//

import Foundation

final class AuthRepository: AuthRepositoryProtocol {
    private let service: AuthAPI
    
    init(service: AuthAPI) {
        self.service = service
    }
    
    func login(email: String, password: String) async throws -> UserLoginDTO {
         let response = service.login(data: UserInputModel(signType: .email,
                                                 phoneNumber: nil,
                                                 email: email,
                                                 password: password))
    }
}
