//
//  GoogleUserEntity.swift
//  RecordNote
//
//  Created by Mohamed Ali on 01/06/2026.
//

import Foundation

struct GoogleUserEntity: Codable, Storeable {
    let email: String
    let name: String
    let idToken: String
}
