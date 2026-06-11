//
//  NoteDetailsViewModel.swift
//  RecordNote
//
//  Created Mohamed Ali on 11/06/2026.
//

import Foundation
import Combine

final class NoteDetailsViewModel: ObservableObject {
    
    // MARK: - Published.
    @Published var category: String = "Meeting"
    @Published var noteModel: NoteRealModelInfoModel
    @Published var selectedTab: NoteTab = .summary
    
    private weak var coordinator: NoteDetailsCoordinator?

    init(coordinator: NoteDetailsCoordinator,noteModel: NoteRealModelInfoModel) {
        self.coordinator = coordinator
        self.noteModel = noteModel
    }
    
    
    // MARK: - Action.
    func backToNotesScreen() {
        coordinator?.dismissToParentScreen()
    }
    
    func threeDotsButtonTapped() {
        
    }
    
    func selectedNoteRowAction(index: Int) {
        
    }
}
