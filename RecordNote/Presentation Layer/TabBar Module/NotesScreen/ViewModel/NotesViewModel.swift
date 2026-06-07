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
    
    // MARK: - Publishers.
    @Published var selectedNoteFilters: NotesFilterValues = .all
    @Published var notes: [MeetingNoteCardAttributes] = .dummyNotes

    init(coordinator: NotesCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Actions.
    func addButtonAction() {
        
    }
}
