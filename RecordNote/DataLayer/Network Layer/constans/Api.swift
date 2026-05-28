//
//  Api.swift
//  testConnection
//
//  Created by Mohamed Ali on 19/01/2024.
//

import Foundation

// currentUrl: https://msr.lnj.sa/
// Quality: https://msr.lnj.sa/
// Production:

struct ErrorObjMessage {
    let type: ErrorStatus
    let message: String
    var operation: String = ""
}

enum ErrorStatus {
    case connection
    case anyThing
    case validation
    case unauthorization
}

enum ApiUrl: String {
    case baseUrl = "https://msr.lnj.sa/"
    case signup = "signup"
    case signin = "signin"
}
