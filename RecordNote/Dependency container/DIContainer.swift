//
//  DIContainer.swift
//  RecordNote
//
//  Created by Mohamed Ali on 26/05/2026.
//

import Foundation

final class DIContainer {

    static let shared = DIContainer()

    private init() {}
    
    func checkMailValidation(emailAddress: String) -> Bool {
        let emailRegex =
            #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#

        return NSPredicate(
                format: "SELF MATCHES %@",
                emailRegex
            ).evaluate(with: emailAddress)
    }

}
