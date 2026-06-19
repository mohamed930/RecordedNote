//
//  NoteDetailsViewModel.swift
//  RecordNote
//
//  Created Mohamed Ali on 11/06/2026.
//

import Foundation
import Combine
import RealmSwift

struct UITaskModel {
    let title: String
    var isDone: Bool
}

final class NoteDetailsViewModel: ObservableObject {
    
    // MARK: - Published.
    @Published var category: String = "Meeting"
    @Published var noteModel: NoteRealModelInfoModel
    @Published var tasksList: [UITaskModel] = []
    @Published var selectedTab: NoteTab = .summary
    @Published var isMenuOpen: Bool = false
    
    private weak var coordinator: NoteDetailsCoordinator?
    var useCases: NoteDetailsUseCases

    init(coordinator: NoteDetailsCoordinator,noteModel: NoteRealModelInfoModel,useCases: NoteDetailsUseCases) {
        self.coordinator = coordinator
        self.noteModel = noteModel
        self.useCases = useCases
        
        tasksList = noteModel.tasks.map {
            return UITaskModel(title: $0.title, isDone: $0.isDone)
        }
    }
    
    
    // MARK: - Action.
    func backToNotesScreen() {
        coordinator?.dismissToParentScreen()
    }
    
    func threeDotsButtonTapped() {
        isMenuOpen.toggle()
    }
    
    func selectedNoteRowAction(index: Int) {
        let flag = useCases.updateTaskDetails(note: noteModel, index: index, isDone: !noteModel.tasks[index].isDone)
        
        if flag {
            tasksList[index].isDone.toggle()
        }
    }
    
    func menuActions(actionType: MenuComponets.MenuAction) {
        switch actionType {
        case .edit:
            edit()
        case .share:
            share()
        case .savePdf:
            savePdf()
        case .delete:
            delete()
        }
    }
}

// MARK: - Menu action.
extension NoteDetailsViewModel {
    func edit() {
        
    }
    
    func share() {
        
    }
    
    func savePdf() {
        
    }
    
    func delete() {
        
    }
}
