//
//  AuthNetworking.swift
//  LNJ-Daftar
//
//  Created by Mohamed Ali on 15/02/2024.
//

import Foundation
import Alamofire

enum AuthNetworking {
    case signUp(data: UserInputModel)
    case login(data: UserInputModel)
}

extension AuthNetworking: TargetType {
    var baseURL: Api {
        return .baseUrl
    }
    
    var path: Api {
        switch self {
            case .signUp:
                return .signup
            case .login:
                return .signin
        }
    }
    
    var method: HTTPMethod {
        switch self {
            case .signUp:
                return .post
            case .login:
                return .post
        }
    }
    
    var task: ParamsTask {
        switch self {
            case .signUp(let data):
                return .requestParameters(parameters: data.params, encoding: JSONEncoding.default)
            
            case .login(let data):
                return .requestParameters(parameters: data.loginParams, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .signUp, .login:
                return [:]
        }
    }
    
    
}
