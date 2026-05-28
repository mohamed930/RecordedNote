//
//  AuthAPI.swift
//  LNJ-Daftar
//
//  Created by Mohamed Ali on 15/02/2024.
//

import UIKit

protocol AuthProtocol {
    
    func signUp(
        params: UserInputModel
    ) async throws -> BaseModel<UserLoginModel>
    
    func login(
        data: UserInputModel
    ) async throws -> BaseModel<UserLoginModel>
}

final class AuthAPI: BaseAPI<AuthNetworking>, AuthProtocol {

    // MARK: - Sign Up
    func signUp(
        params: UserInputModel
    ) async throws -> BaseModel<UserLoginModel> {
        return try await request(
            target: .signUp(data: params),
            responseModel: BaseModel<UserLoginModel>.self
        )
    }

    // MARK: - Login
    func login(
        data: UserInputModel
    ) async throws -> BaseModel<UserLoginModel> {

        return try await request(
            target: .login(data: data),
            responseModel: BaseModel<UserLoginModel>.self
        )
    }

    // MARK: - Device UUID
    /// Get device UUID
    private func getVendorIdentifier() -> String? {
        UIDevice.current.identifierForVendor?.uuidString
    }
}
