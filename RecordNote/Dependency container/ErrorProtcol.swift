//
//  ErrorProtcol.swift
//  Masar
//
//  Created by Mohamed Ali on 16/10/2024.
//

import Foundation

protocol ErrorProtocol {

    func handleError(
        _ error: Error
    ) -> ErrorObjMessage

    func sendAuthFailed() -> ErrorObjMessage
}

// MARK: - Default Implementation

extension ErrorProtocol {

    func handleError(
        _ error: Error
    ) -> ErrorObjMessage {

        // API Errors

        if let apiError = error as? APIError {

            switch apiError {

            case .unauthorized:

                return ErrorObjMessage(
                    type: .unauthorization,
                    message: "Session expired"
                )

            case .serverError:

                return ErrorObjMessage(
                    type: .anyThing,
                    message: "Server error occurred"
                )

            case .invalidURL:

                return ErrorObjMessage(
                    type: .anyThing,
                    message: "Invalid URL"
                )

            case .invalidResponse:

                return ErrorObjMessage(
                    type: .anyThing,
                    message: "Invalid response"
                )

            case .decodingError:

                return ErrorObjMessage(
                    type: .anyThing,
                    message: "Failed to decode data"
                )

            case .unknown:

                return ErrorObjMessage(
                    type: .anyThing,
                    message: "Unknown error occurred"
                )
            }
        }

        // URLSession Errors

        if let urlError = error as? URLError {

            switch urlError.code {

            case .notConnectedToInternet,
                    .networkConnectionLost,
                    .timedOut:

                return ErrorObjMessage(
                    type: .connection,
                    message: "Check your internet connection"
                )

            default:

                return ErrorObjMessage(
                    type: .anyThing,
                    message: urlError.localizedDescription
                )
            }
        }

        // Default

        return ErrorObjMessage(
            type: .anyThing,
            message: error.localizedDescription
        )
    }

    func sendAuthFailed() -> ErrorObjMessage {

        return ErrorObjMessage(
            type: .unauthorization,
            message: "تسجيل الدخول"
        )
    }
}
