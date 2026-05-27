//
//  AuthUseCases.swift
//  RecordNote
//
//  Created by Mohamed Ali on 27/05/2026.
//

import Foundation

protocol AuthRepositoryProtocol {
    func login(
        email: String,
        password: String
    ) async throws -> UserLoginDTO
}
