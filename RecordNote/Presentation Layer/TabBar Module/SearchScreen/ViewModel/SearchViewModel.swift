//
//  SearchViewModel.swift
//  RecordNote
//
//  Created Mohamed Ali on 03/06/2026.
//

import Foundation
import Combine
import RealmSwift

final class SearchViewModel: ObservableObject {
    
    // MARK: - Publishers.
    @Published var searchText: String = ""
    @Published var latestSearchResult: [SuggestionModel] = []
    @Published var date = "All Time"
    @Published var category = "All"
    @Published var hasTasks = false
    @Published var results: [MeetingNote] = []
    @Published var filterCategpry: String? = "all"
    @Published var selectedDates: Set<DateComponents> = [] {
        didSet {
            date = formatSelectedDates()
        }
    }
    
    private weak var coordinator: SearchCoordinator?
    var useCases: SearchUseCases

    init(coordinator: SearchCoordinator,useCases: SearchUseCases) {
        self.coordinator = coordinator
        self.useCases = useCases
    }
    
    // MARK: - Actions.
    func search() {
        results = useCases.fetchResults(str: searchText)
    }
    
    func suggestionTappedAction(title: String) {
        searchText = title
        
        results = useCases.fetchResults(str: searchText)
    }
    
    func searchWithFilter() {
        let dates: [Date] = selectedDates
            .compactMap { Calendar.current.date(from: $0) }
            .sorted()
        
        if filterCategpry?.lowercased() == "all" {
            filterCategpry = nil
        }
        
        results = useCases.fetchResults(str: searchText,date: dates, category: filterCategpry)
    }
    
    func moveToNoteDetailsScreen(note: MeetingNote) {
        guard let note = useCases.convertToNoteRealModel(id: note.id) else { return }
        coordinator?.moveToNoteDetailsScreen(note: note)
    }
    
    func deleteSuggestion(_ note: SuggestionModel) {
        let response = useCases.deleteSuggestion(id: note.id)

        if response {
            latestSearchResult = useCases.fetchSuggestion()
        }
    }
}

extension SearchViewModel {
    
    private func formatSelectedDates() -> String {

        let calendar = Calendar.current

        let dates = selectedDates
            .compactMap { calendar.date(from: $0) }
            .sorted()

        guard let first = dates.first else {
            return "All Time"
        }

        let formatter = DateFormatter()
        formatter.locale = .current

        let currentYear = calendar.component(.year, from: Date())

        func string(for date: Date) -> String {
            let year = calendar.component(.year, from: date)

            formatter.dateFormat = year == currentYear
                ? "dd-MMM"
                : "dd-MMM-yyyy"

            return formatter.string(from: date)
        }

        guard let last = dates.last, first != last else {
            return string(for: first)
        }

        return "\(string(for: first)) to \(string(for: last))"
    }
}
