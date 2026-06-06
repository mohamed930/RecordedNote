//
//  HomeRespositoryProtocol.swift
//  RecordNote
//
//  Created by Mohamed Ali on 06/06/2026.
//

import Foundation

protocol HomeRespositoryProtocol {
    func fetchNotes() -> [MeetingNote]
    func fetchUserName() -> String?
}
