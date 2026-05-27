//
//  UserLoginModel.swift
//  RecordNote
//
//  Created by Mohamed Ali on 27/05/2026.
//


struct UserLoginModel: Codable {
    let partnerToken, name, age, mail: String
    let level, phone: String

    enum CodingKeys: String, CodingKey {
        case partnerToken = "partner_token"
        case name, age, mail, level, phone
    }
}
