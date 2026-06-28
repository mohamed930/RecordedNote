//
//  NotesViewModel.swift
//  RecordNote
//
//  Created Mohamed Ali on 03/06/2026.
//

import Foundation
import Combine

final class NotesViewModel: ObservableObject {
    private weak var coordinator: NotesCoordinator?
    private let useCases: NotesUseCases
    
    // MARK: - Publishers.
    @Published var notes: [MeetingNoteCardAttributes] = []
    @Published var selectedNoteFilters: NotesFilterValues = .all {
        willSet {
            notes = useCases.fetchFiltersNotes(filter: newValue)
        }
    }

    init(coordinator: NotesCoordinator,useCases: NotesUseCases) {
        self.coordinator = coordinator
        self.useCases = useCases
        
        fetchNotes()
    }
    
    // MARK: - Actions.
    private func fetchNotes() {
        notes = useCases.fetchNotes()
    }

    func refreshNotesContent() {
        fetchNotes()
    }
    
    func addButtonAction() {
        coordinator?.moveToNewNoteScreen()
    }
    
    func moveToNoteDetailsScreen(id: String) {
        guard let model = useCases.convertNoteDTOToFullObject(id: id) else { return }
        coordinator?.moveToNoteDetailsScreen(note: model)
    }
}
