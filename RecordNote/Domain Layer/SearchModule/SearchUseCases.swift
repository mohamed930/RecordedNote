//
//  SearchUseCases.swift
//  RecordNote
//
//  Created by Mohamed Ali on 14/06/2026.
//

import Foundation

class SearchUseCases {
    private var respotery: SearchResportryProtocol
    
    init(respotery: SearchResportryProtocol) {
        self.respotery = respotery
    }
    
    func fetchSuggestion() -> [String] {
        respotery.fetchSuggestion()
    }
    
    func fetchResults(str: String,date: Date? = nil,category: NotesFilterValues? = nil) -> [MeetingNote] {
        respotery.fetchResults(str: str, date: date, category: category)
    }
    
    func convertToNoteRealModel(id: String) -> NoteRealModelInfoModel? {
        respotery.fetchNote(id: id)
    }
}
