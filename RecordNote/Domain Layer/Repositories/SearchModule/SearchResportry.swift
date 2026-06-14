//
//  SearchResportry.swift
//  RecordNote
//
//  Created by Mohamed Ali on 14/06/2026.
//

import Foundation

final class SearchResportry: SearchResportryProtocol {
    
    private var realm: RealmStorageProtocol
    
    init(realm: RealmStorageProtocol) {
        self.realm = realm
    }
    
    func saveSuggestion(str: String) -> Bool {
        
        let model: SuggestionModel = SuggestionModel()
        model.id = UUID().uuidString
        model.suggest = str
        
        return realm.write(model)
    }
    
    func fetchSuggestion() -> [String] {
        let suggestion: [SuggestionModel] = realm.objects()
        let finalSuggestion = Array(Set(suggestion))
        
        return finalSuggestion.prefix(3).map { $0.convertToString() }
    }
    
    func fetchResults(str: String, date: Date?, category: NotesFilterValues?) -> [MeetingNote] {
        
        let notes: [NoteRealModelInfoModel] = realm.objects { note in
            note.name.lowercased().contains(str.lowercased())
        }
        
        if let date = date {
            var filtered = notes
            
            let calendar = Calendar.current

            let startOfDay = calendar.startOfDay(for: date)
            let endOfDay = calendar.date(
                byAdding: .day,
                value: 1,
                to: startOfDay
            )!

            filtered = notes.filter({$0.date >= startOfDay && $0.date <= endOfDay })
            
            if let category = category {
                filtered = notes.filter {($0.name.lowercased().contains(category.rawValue.lowercased().lowercased()) || $0.name.lowercased().contains(category.rawValue.lowercased()))}
                
                if !filtered.isEmpty {
                    _ = saveSuggestion(str: str)
                }
                
                return filtered.map { $0.convertToDTO() }
            }
            else {
                
                if !filtered.isEmpty {
                    _ = saveSuggestion(str: str)
                }
                
                return filtered.map { $0.convertToDTO() }
            }
        }
        
        if let category = category {
            let filtered = notes.filter {($0.name.lowercased().contains(category.rawValue.lowercased().lowercased()) || $0.name.lowercased().contains(category.rawValue.lowercased()))}
            
            if !filtered.isEmpty {
                _ = saveSuggestion(str: str)
            }
            
            return filtered.map { $0.convertToDTO() }
        }
        
        if !notes.isEmpty {
            _ = saveSuggestion(str: str)
        }
        
        return notes.map { $0.convertToDTO() }
    }
}
