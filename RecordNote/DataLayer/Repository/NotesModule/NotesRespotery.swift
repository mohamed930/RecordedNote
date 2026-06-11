//
//  NotesRespotery.swift
//  RecordNote
//
//  Created by Mohamed Ali on 11/06/2026.
//

import Foundation

final class NotesRespotery: NotesRespoteryProtocol {
    
    private var realm: RealmStorageProtocol
    
    init(realm: RealmStorageProtocol) {
        self.realm = realm
    }
    
    func fetchNotes() -> [MeetingNoteCardAttributes] {
        let allNotes: [NoteRealModelInfoModel] = realm.objects()
        
        return allNotes.map { $0.convertToMeetingNoteCardAttributes() }
    }
    
    func filterNotes(filter: NotesFilterValues) -> [MeetingNoteCardAttributes] {
        let allNotes: [NoteRealModelInfoModel] = realm.objects()
        
        switch filter {
        case .all:
            return allNotes.map { $0.convertToMeetingNoteCardAttributes() }
        case .favorites:
            let filtered = allNotes.filter({ $0.isFav })
            return filtered.map { $0.convertToMeetingNoteCardAttributes() }
        case .meetings:
            let filtered = allNotes.filter({ ($0.name.lowercased().contains("Meeting".lowercased().lowercased()) || $0.name.lowercased().contains("Meetings".lowercased())) })
            return filtered.map { $0.convertToMeetingNoteCardAttributes() }
        case .ideas:
            let filtered = allNotes.filter({ ($0.name.lowercased().contains("Ideas".lowercased()) || $0.name.contains("ideas".lowercased().lowercased())) })
            return filtered.map { $0.convertToMeetingNoteCardAttributes() }
        }
    }
    
}
