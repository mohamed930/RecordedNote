//
//  SearchViewModel.swift
//  RecordNote
//
//  Created Mohamed Ali on 03/06/2026.
//

import Foundation
import Combine

final class SearchViewModel: ObservableObject {
    
    // MARK: - Publishers.
    @Published var searchText: String = ""
    @Published var latestSearchResult: [String] = []
    @Published var date = "All Time"
    @Published var category = "All"
    @Published var hasTasks = false
    @Published var results: [MeetingNote] = []
    
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
        
    }
}
