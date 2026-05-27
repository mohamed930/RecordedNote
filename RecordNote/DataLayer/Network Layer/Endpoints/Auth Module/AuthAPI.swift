//
//  AuthAPI.swift
//  LNJ-Daftar
//
//  Created by Mohamed Ali on 15/02/2024.
//

import UIKit
import Combine

protocol AuthProtocol {
    func signUp(params: UserInputModel) -> Future<BaseModel<UserSignupModel>,NSError>
    func login(data: UserInputModel) -> Future<BaseModel<UserLoginModel>,NSError>
}


class AuthAPI: BaseAPI<AuthNetworking>, AuthProtocol {
    
    func signUp(params: UserInputModel) -> Future<BaseModel<UserSignupModel>, NSError> {
        requestPublisher(Target: .signUp(data: params), ClassName: BaseModel<UserSignupModel>.self)
    }
    
    func login(data: UserInputModel) -> Future<BaseModel<UserLoginModel>, NSError> {
        requestPublisher(Target: .login(data: data), ClassName: BaseModel<UserLoginModel>.self)
    }
    
    /// this function try to get UUId for device to sent it to database.
    /// - Returns: return UUId to device.
    private func getVendorIdentifier() -> String? {
        let currentDevice = UIDevice.current
        let vendorIdentifier = currentDevice.identifierForVendor?.uuidString
        return vendorIdentifier
    }
}
