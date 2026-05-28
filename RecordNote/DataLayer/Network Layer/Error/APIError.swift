//
//  APIError.swift
//  RecordNote
//
//  Created by Mohamed Ali on 28/05/2026.
//

import Foundation

enum APIError: Error, LocalizedError {

    case invalidURL
    case invalidResponse
    case decodingError
    case unauthorized
    case serverError
    case unknown

    var errorDescription: String? {

        switch self {

        case .invalidURL:
            return "Invalid URL"

        case .invalidResponse:
            return "Invalid Response"

        case .decodingError:
            return "Failed To Decode Response"

        case .unauthorized:
            return "Unauthorized"

        case .serverError:
            return "Server Error"

        case .unknown:
            return "Something Went Wrong"
        }
    }
}
