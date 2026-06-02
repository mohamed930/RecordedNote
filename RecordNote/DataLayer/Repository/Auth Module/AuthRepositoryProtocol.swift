//
//  AuthRepositoryProtocol.swift
//  RecordNote
//
//  Created by Mohamed Ali on 27/05/2026.
//

import Foundation

protocol AuthRepositoryProtocol {
    func login(
        email: String,
        password: String
    ) async throws -> Bool
    
    func signup(
        fullName: String,
        email: String,
        password: String
    ) async throws -> String
    
    func loginWithGoogle() async throws -> Bool
    
    func signupWithGoogle() async throws -> Bool
    
    func singInWtihApple() async throws -> Bool
    
    func singOutWtihApple() async throws -> Bool
}
