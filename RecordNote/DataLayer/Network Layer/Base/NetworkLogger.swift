//
//  NetworkLogger.swift
//  RecordNote
//
//  Created by Mohamed Ali on 28/05/2026.
//

import Foundation

struct NetworkLogger {

    static func logRequest(_ request: URLRequest) {

        #if DEBUG

        print("""

        🚀 REQUEST
        =====================================

        URL:
        \(request.url?.absoluteString ?? "")

        METHOD:
        \(request.httpMethod ?? "")

        HEADERS:
        \(request.allHTTPHeaderFields ?? [:])

        BODY:
        \(prettyBody(request.httpBody))

        =====================================

        """)

        #endif
    }

    static func logResponse(
        data: Data?,
        response: URLResponse?,
        error: Error?,
        duration: Double
    ) {

        #if DEBUG

        guard let httpResponse = response as? HTTPURLResponse else {

            print("""

            ❌ INVALID RESPONSE
            =====================================

            ERROR:
            \(error?.localizedDescription ?? "")

            =====================================

            """)

            return
        }

        print("""

        ✅ RESPONSE
        =====================================

        URL:
        \(httpResponse.url?.absoluteString ?? "")

        STATUS CODE:
        \(httpResponse.statusCode)

        DURATION:
        \(String(format: "%.2f", duration)) sec

        RESPONSE:
        \(prettyData(data))

        ERROR:
        \(error?.localizedDescription ?? "No Error")

        =====================================

        """)

        #endif
    }
}

// MARK: - Helpers
private extension NetworkLogger {

    static func prettyData(_ data: Data?) -> String {

        guard let data else { return "No Data" }

        do {

            let object = try JSONSerialization.jsonObject(
                with: data
            )

            let prettyData = try JSONSerialization.data(
                withJSONObject: object,
                options: [.prettyPrinted]
            )

            return String(
                data: prettyData,
                encoding: .utf8
            ) ?? ""

        } catch {

            return String(
                data: data,
                encoding: .utf8
            ) ?? ""
        }
    }

    static func prettyBody(_ data: Data?) -> String {

        guard let data else { return "Empty Body" }

        return prettyData(data)
    }
}
