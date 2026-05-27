//
//  BaseModel.swift
//  RecordNote
//
//  Created by Mohamed Ali on 27/05/2026.
//


struct BaseModel<T: Codable>: Codable {
    var data: T?
    var version: String?
    let itemsCount: Int?
    let success: Bool
    let statusCode: Int
    let message: String?

    enum CodingKeys: String, CodingKey {
        case data
        case version
        case itemsCount
        case success
        case statusCode
        case message
    }
}
