//
//  Storeable.swift
//  RecordNote
//
//  Created by Mohamed Ali on 01/06/2026.
//

import Foundation

extension Storeable where Self: Codable {

    var storeData: Data? {
        try? JSONEncoder().encode(self)
    }

    init?(storeData: Data?) {

        guard let storeData else {
            return nil
        }

        guard let object = try? JSONDecoder().decode(
            Self.self,
            from: storeData
        ) else {
            return nil
        }

        self = object
    }
}
