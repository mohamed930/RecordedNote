//
//  SearchResportryProtocol.swift
//  RecordNote
//
//  Created by Mohamed Ali on 14/06/2026.
//

import Foundation

protocol SearchResportryProtocol {
    func saveSuggestion(str: String) -> Bool
    func fetchSuggestion() -> [String]
    func fetchResults(str: String,date: Date?,category: NotesFilterValues?) -> [MeetingNote]
}
