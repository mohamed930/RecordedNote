//
//  EditNoteViewModel.swift
//  RecordNote
//
//  Created by Mohamed Ali on 29/06/2026.
//

import Foundation
import Combine

class EditNoteViewModel: ObservableObject {
    
    // MARK: - Publishers.
    @Published var note: NoteDTO
    private var noteModel: NoteRealModelInfoModel
    @Published var noteTitle: String = ""
    @Published var category: String = "Meeting"
    
    // MARK: - Depandancy
    weak var coordinator: EditNoteCoordinator?
    
    init(coordinator: EditNoteCoordinator?,noteModel: NoteRealModelInfoModel) {
        self.coordinator = coordinator
        self.noteModel = noteModel
        self.note = noteModel.toDTO()
        
        fetchData()
    }
    
    func fetchData() {
        noteTitle = note.name
    }
    
    // MARK: - Actions.
    func backToNoteDetailsScreen() {
        coordinator?.moveToNoteDetailsScreen()
    }
    
    func clear() {
        noteTitle = ""
    }
    
    func updateDate() {
        
    }
    
    func updateTime() {
        
    }
}
