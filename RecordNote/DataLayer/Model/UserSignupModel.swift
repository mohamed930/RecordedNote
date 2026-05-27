//
//  UserSignupModel.swift
//  RecordNote
//
//  Created by Mohamed Ali on 27/05/2026.
//


struct UserSignupModel: Codable {
    let partnerToken: String
    
    enum CodingKeys: String,CodingKey {
        case partnerToken = "partner_token"
    }
}