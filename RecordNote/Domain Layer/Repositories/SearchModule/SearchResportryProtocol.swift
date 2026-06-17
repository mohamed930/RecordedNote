//
//  SearchResportryProtocol.swift
//  RecordNote
//
//  Created by Mohamed Ali on 14/06/2026.
//

import Foundation

protocol SearchResportryProtocol {
    func saveSuggestion(str: String) -> Bool
    func fetchSuggestion() -> [SuggestionModel]
    func fetchResults(str: String,date: [Date]?,category: String?) -> [MeetingNote]
    func fetchNote(id: String) -> NoteRealModelInfoModel?
    func deleteSuggestion(id: String) -> Bool
}
