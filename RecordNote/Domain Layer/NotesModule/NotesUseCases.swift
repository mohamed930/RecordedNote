//
//  NotesUseCases.swift
//  RecordNote
//
//  Created by Mohamed Ali on 06/06/2026.
//

import Foundation

final class NotesUseCases {
    private let repository: HomeRespository

    init(repository: HomeRespository) {
        self.repository = repository
    }

    func fetchAllNotes() -> [MeetingNote] {
        repository.fetchNotes()
    }
    
    func fetchUserName() -> String {
        guard let userName = repository.fetchUserName() else {
            return ""
        }
        
        return userName
    }
}

