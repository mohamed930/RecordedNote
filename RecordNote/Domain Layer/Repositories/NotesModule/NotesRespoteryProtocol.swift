//
//  NotesRespoteryProtocol.swift
//  RecordNote
//
//  Created by Mohamed Ali on 11/06/2026.
//

import Foundation

protocol NotesRespoteryProtocol {
    func fetchNotes() -> [MeetingNoteCardAttributes]
    func filterNotes(filter: NotesFilterValues) -> [MeetingNoteCardAttributes]
    func convertNoteToNoteRealModel(id: String) -> NoteRealModelInfoModel?
}
