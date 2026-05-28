//
//  BaseAPI.swift
//

import Foundation
import Alamofire

// MARK: - File Upload

struct FileUpload {

    let data: Data
    let name: String
    let fileName: String
    let mimeType: String
}

// MARK: - Base API

class BaseAPI<T: TargetType> {

    // MARK: - Properties

    private let session: URLSession

    // MARK: - Init

    init(session: URLSession = .shared) {
        self.session = session
    }

    // MARK: - Request

    func request<M: Decodable>(
        target: T,
        responseModel: M.Type
    ) async throws -> M {

        let request = try buildRequest(target: target)

        NetworkLogger.logRequest(request)

        let startDate = Date()

        do {

            let (data, response) = try await session.data(
                for: request
            )

            let duration = Date().timeIntervalSince(startDate)

            NetworkLogger.logResponse(
                data: data,
                response: response,
                error: nil,
                duration: duration
            )

            try validateResponse(response)

            return try decode(
                data: data,
                model: responseModel
            )

        } catch {

            let duration = Date().timeIntervalSince(startDate)

            NetworkLogger.logResponse(
                data: nil,
                response: nil,
                error: error,
                duration: duration
            )

            throw error
        }
    }

    // MARK: - Upload

    func upload<M: Decodable>(
        target: T,
        params: [String: Any]?,
        file: FileUpload,
        responseModel: M.Type
    ) async throws -> M {

        guard let url = URL(
            string: target.baseURL.rawValue + target.path.rawValue
        ) else {
            throw APIError.invalidURL
        }

        let boundary = UUID().uuidString

        var request = URLRequest(url: url)

        request.httpMethod = target.method.rawValue

        request.setValue(
            "multipart/form-data; boundary=\(boundary)",
            forHTTPHeaderField: "Content-Type"
        )

        target.headers?.forEach {
            request.setValue(
                $0.value,
                forHTTPHeaderField: $0.key
            )
        }

        request.httpBody = createMultipartBody(
            params: params,
            file: file,
            boundary: boundary
        )

        NetworkLogger.logRequest(request)

        let startDate = Date()

        do {

            let (data, response) = try await session.data(
                for: request
            )

            let duration = Date().timeIntervalSince(startDate)

            NetworkLogger.logResponse(
                data: data,
                response: response,
                error: nil,
                duration: duration
            )

            try validateResponse(response)

            return try decode(
                data: data,
                model: responseModel
            )

        } catch {

            let duration = Date().timeIntervalSince(startDate)

            NetworkLogger.logResponse(
                data: nil,
                response: nil,
                error: error,
                duration: duration
            )

            throw error
        }
    }
}

// MARK: - Helpers

private extension BaseAPI {

    func buildRequest(
        target: T
    ) throws -> URLRequest {

        guard let url = URL(
            string: target.baseURL.rawValue + target.path.rawValue
        ) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)

        request.httpMethod = target.method.rawValue

        request.timeoutInterval = 30

        target.headers?.forEach {
            request.setValue(
                $0.value,
                forHTTPHeaderField: $0.key
            )
        }

        switch target.task {

        case .requestPlain:
            break

        case .requestParameters(
            let parameters,
            let encoding
        ):

            if encoding is JSONEncoding {

                request.setValue(
                    "application/json",
                    forHTTPHeaderField: "Content-Type"
                )

                request.httpBody = try JSONSerialization.data(
                    withJSONObject: parameters
                )

            } else {

                var components = URLComponents(
                    url: url,
                    resolvingAgainstBaseURL: false
                )

                components?.queryItems = parameters.map {

                    URLQueryItem(
                        name: $0.key,
                        value: "\($0.value)"
                    )
                }

                request.url = components?.url
            }
        }

        return request
    }

    // MARK: - Decode

    func decode<M: Decodable>(
        data: Data,
        model: M.Type
    ) throws -> M {

        do {

            let decoder = JSONDecoder()

            decoder.keyDecodingStrategy = .convertFromSnakeCase

            return try decoder.decode(
                model,
                from: data
            )

        } catch {

            throw APIError.decodingError
        }
    }

    // MARK: - Validate

    func validateResponse(
        _ response: URLResponse
    ) throws {

        guard let response = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        switch response.statusCode {

        case 200...299:
            break

        case 401:
            throw APIError.unauthorized

        case 500...599:
            throw APIError.serverError

        default:
            throw APIError.unknown
        }
    }

    // MARK: - Multipart

    func createMultipartBody(
        params: [String: Any]?,
        file: FileUpload,
        boundary: String
    ) -> Data {

        var body = Data()

        let lineBreak = "\r\n"

        // Parameters

        params?.forEach { key, value in

            body.append("--\(boundary)\(lineBreak)")

            body.append(
                "Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)"
            )

            body.append("\(value)\(lineBreak)")
        }

        // File

        body.append("--\(boundary)\(lineBreak)")

        body.append(
            "Content-Disposition: form-data; name=\"\(file.name)\"; filename=\"\(file.fileName)\"\(lineBreak)"
        )

        body.append(
            "Content-Type: \(file.mimeType)\(lineBreak + lineBreak)"
        )

        body.append(file.data)

        body.append(lineBreak)

        body.append("--\(boundary)--\(lineBreak)")

        return body
    }
}

// MARK: - Data Extension

extension Data {

    mutating func append(
        _ string: String
    ) {

        if let data = string.data(
            using: .utf8
        ) {
            append(data)
        }
    }
}
