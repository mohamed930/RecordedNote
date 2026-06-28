//
//  HomeViewModel.swift
//  RecordNote
//
//  Created Mohamed Ali on 03/06/2026.
//

import Foundation
import Combine
import SwiftUI
import RealmSwift

final class HomeViewModel: ObservableObject {
    
    // MARK: - Published.
    @Published var userName: String = ""
    @Published var notes: [MeetingNote] = []
    @Published var isEmpty: Bool = true
    
    // MARK: - Objects.
    private weak var coordinator: HomeCoordinator?
    var useCases: NotesUseCases

    init(coordinator: HomeCoordinator,useCases:NotesUseCases) {
        self.coordinator = coordinator
        self.useCases = useCases
        
        print(Realm.Configuration.defaultConfiguration.fileURL?.path ?? "")
        fetchNotes()
        fetchUerName()
        
    }
    
    // MARK: - Actions.
    func recordNoteButtonAction() {
        
    }
    
    func seeAllButtonAction() {
        coordinator?.moveToNotesScreen()
    }
    
    func fetchNotes() {
        let fetchedNotes = useCases.fetchAllNotes()
        
        if fetchedNotes.isEmpty {
            isEmpty = true
        }
        else {
            isEmpty = false
            notes = fetchedNotes
        }
    }
    
    func fetchUerName() {
        userName = useCases.fetchUserName()
    }
    
    func moveToNoteDetailsScreen(id: String) {
        guard let model: NoteRealModelInfoModel = useCases.convertNoteDTOToFullObject(id: id) else { return }
        
        coordinator?.moveToNoteDetailsScreen(note: model)
    }

    func refreshNotesContent() {
        fetchNotes()
    }
}
