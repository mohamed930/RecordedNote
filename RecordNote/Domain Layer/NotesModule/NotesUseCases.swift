//
//  NotesUseCases.swift
//  RecordNote
//
//  Created by Mohamed Ali on 06/06/2026.
//

import Foundation

final class NotesUseCases {
    private let repository: HomeRespository = HomeRespository(realm: RealmStorage(), local: LocalStorage())
    private let notesRespotery: NotesRespoteryProtocol

    init(notesRespotery: NotesRespoteryProtocol) {
        self.notesRespotery = notesRespotery
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
    
    func fetchNotes() -> [MeetingNoteCardAttributes] {
        notesRespotery.fetchNotes()
    }
    
    func fetchFiltersNotes(filter: NotesFilterValues) -> [MeetingNoteCardAttributes] {
        notesRespotery.filterNotes(filter: filter)
    }
    
    func convertNoteDTOToFullObject(id: String) -> NoteRealModelInfoModel? {
        notesRespotery.convertNoteToNoteRealModel(id: id)
    }
}
