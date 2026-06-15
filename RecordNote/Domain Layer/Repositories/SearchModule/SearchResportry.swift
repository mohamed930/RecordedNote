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

        let trimmed = str.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !trimmed.isEmpty else {
            return false
        }

        let suggestions: [SuggestionModel] = realm.objects {
            $0.suggest.lowercased() == trimmed.lowercased()
        }

        guard suggestions.isEmpty else {
            return true
        }

        let suggestion = SuggestionModel()
        suggestion.suggest = trimmed

        return realm.write(suggestion)
    }
    
    func fetchSuggestion() -> [SuggestionModel] {
        let suggestion: [SuggestionModel] = realm.objects()

        var seen = Set<String>()

        let finalSuggestion = suggestion.filter {
            seen.insert($0.suggest.lowercased()).inserted
        }

        return finalSuggestion.prefix(3).map { suggestion in
            let detachedSuggestion = SuggestionModel()
            detachedSuggestion.id = suggestion.id
            detachedSuggestion.suggest = suggestion.suggest
            return detachedSuggestion
        }
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

            filtered = notes.filter({ $0.date >= startOfDay && $0.date <= endOfDay })
            
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
    
    func fetchNote(id: String) -> NoteRealModelInfoModel? {
        let note: NoteRealModelInfoModel? = realm.object({
            $0.id == id
        })
        
        return note
    }
    
    func deleteSuggestion(id: String) -> Bool {
        
        guard let suggestion: SuggestionModel = realm.object(id) else {
            return false
        }

        return realm.delete(suggestion)
    }
}
