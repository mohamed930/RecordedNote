//
//  AuthUseCases.swift
//  RecordNote
//
//  Created by Mohamed Ali on 28/05/2026.
//

import Foundation

final class AuthUseCase {
    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func login(email: String, password: String) async throws -> Bool {
        try await repository.login(email: email, password: password)
    }
    
    func signup(name: String,email: String, password: String) async throws -> String {
        try await repository.signup(fullName: name, email: email, password: password)
    }
    
    func singInGoogle() async throws -> Bool {
        try await repository.loginWithGoogle()
    }
    
    func singUpGoogle() async throws -> Bool {
        try await repository.signupWithGoogle()
    }
    
    func singInApple() async throws -> Bool {
        try await repository.singInWtihApple()
    }
    
    func singUpApple() async throws -> Bool {
        try await repository.singOutWtihApple()
    }
}
