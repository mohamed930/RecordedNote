//
//  UserInputModel.swift
//  RecordNote
//
//  Created by Mohamed Ali on 27/05/2026.
//

import Foundation

enum SignTypeValues: String {
    case phone
    case email = "mail"
}


struct UserInputModel {
    var name: String
    var signType: SignTypeValues
    var email: String?
    var phoneNumber: String?
    var password: String?
    var firebaseToken: String = ""
    
    init(name: String, signType: SignTypeValues, email: String? = nil, phoneNumber: String? = nil, password: String? = nil, firebaseToken: String) {
        self.name = name
        self.signType = signType
        self.email = email
        self.phoneNumber = phoneNumber
        self.password = password
        self.firebaseToken = firebaseToken
    }
    
    init(signType: SignTypeValues,phoneNumber: String?,email: String?,password: String?) {
        self.signType = signType
        switch signType {
        case .phone:
            self.phoneNumber = phoneNumber
            self.password = password
            self.name = ""
            self.email = nil
            self.firebaseToken = ""
        case .email:
            self.phoneNumber = nil
            self.password = nil
            self.name = ""
            self.email = email
            self.firebaseToken = ""
        }
    }
    
    var params: [String:Any] {
        switch signType {
        case .phone:
            return [
                "name" : name,
                "sign_type": signType.rawValue,
                "phone_number": phoneNumber ?? "",
                "email": email ?? "",
                "password": password ?? "",
                "firebase_token": firebaseToken
            ]
        case .email:
            return [
                "name" : name,
                "sign_type": signType.rawValue,
                "email": email ?? "",
                "password": "111",
                "firebase_token": firebaseToken
            ]
        }
    }
    
    var loginParams: [String: Any] {
        switch signType {
        case .phone:
            return [
                "sign_type": signType.rawValue,
                "phone_number": phoneNumber ?? "",
                "password": password ?? ""
            ]
        case .email:
            return [
                "sign_type": signType.rawValue,
                "email": email ?? "",
                "password": "111",
            ]
        }
    }
}
