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
    
    func fetchResults(str: String,date: [Date]?,category: String?) -> [MeetingNote] {

        let calendar = Calendar.current

        var filtered: [NoteRealModelInfoModel] = realm.objects {
            $0.name.lowercased().contains(str.lowercased())
        }

        // Date filter
        if let dates = date, !dates.isEmpty {

            let sortedDates = dates.sorted()

            if sortedDates.count == 1 {

                let start = calendar.startOfDay(
                    for: sortedDates[0]
                )

                let end = calendar.date(
                    byAdding: .day,
                    value: 1,
                    to: start
                )!

                filtered = filtered.filter {
                    $0.date >= start &&
                    $0.date < end
                }

            } else {

                let start = calendar.startOfDay(
                    for: sortedDates.first!
                )

                let end = calendar.date(
                    byAdding: .day,
                    value: 1,
                    to: sortedDates.last!
                )!

                filtered = filtered.filter {
                    $0.date >= start &&
                    $0.date < end
                }
            }
        }

        // Category filter
        if let category,
           !category.isEmpty {

            filtered = filtered.filter {
                $0.name.lowercased()
                    .contains(category.lowercased())
            }
        }

        if !filtered.isEmpty {
            _ = saveSuggestion(str: str)
        }

        return filtered.map {
            $0.convertToDTO()
        }
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
