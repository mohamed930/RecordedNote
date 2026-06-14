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
    @Published var latestSearchResult: [NoteRealModelInfoModel] = [.mock]
    @Published var date = "All Time"
    @Published var category = "All"
    @Published var hasTasks = false
    @Published var results: [MeetingNote] = .data
    
    private weak var coordinator: SearchCoordinator?

    init(coordinator: SearchCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Actions.
    func search() {
        
    }
    
    func suggestionTappedAction(title: String) {
        
    }
}
