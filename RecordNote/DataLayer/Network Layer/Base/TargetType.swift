//
//  TargetType.swift
//  testConnection
//
//  Created by Mohamed Ali on 19/01/2024.
//

import Foundation
import Alamofire


enum HTTPMethod : String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum ParamsTask {
    case requestPlain
    case requestParameters(parameters : [String:Any] , encoding: ParameterEncoding)
}

protocol TargetType {
    var baseURL: Api { get }
    var path: Api { get }
    var method: HTTPMethod { get }
    var task: ParamsTask { get }
    var headers: [String:String]? { get }
}
