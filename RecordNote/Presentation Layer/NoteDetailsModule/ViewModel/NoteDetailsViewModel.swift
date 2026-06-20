//
//  NoteDetailsViewModel.swift
//  RecordNote
//
//  Created Mohamed Ali on 11/06/2026.
//

import SwiftUI
import Combine
import RealmSwift
import FittedSheets

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
    @Published var pdfUrl: URL?
    private var selectedTabs: [PDFContentOption] = []
    
    private weak var coordinator: NoteDetailsCoordinator?
    var useCases: NoteDetailsUseCases
    private let sheetManager: CustomSheetManager

    init(
        coordinator: NoteDetailsCoordinator,
        noteModel: NoteRealModelInfoModel,
        useCases: NoteDetailsUseCases,
        sheetManager: CustomSheetManager
    ) {
        self.coordinator = coordinator
        self.noteModel = noteModel
        self.useCases = useCases
        self.sheetManager = sheetManager
        
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
    
    @MainActor
    func savePdf() {
        isMenuOpen = false

        sheetManager.present(
            content: {
                PDFOptionsSheet { [weak self] selectedTab in
                        guard let self else { return }
                        
                        selectedTabs = Array(selectedTab)
                    }
                    buttonTapped: { [weak self] finishLoading in
                        guard let self else {
                            finishLoading()
                            return
                        }
                        
                        Task { [weak self] in
                            guard let self else {
                                finishLoading()
                                return
                            }
                            
                            do {
                                pdfUrl = try await useCases.execute(
                                    note: noteModel,
                                    options: selectedTabs
                                )
                                
                                print("F: \(pdfUrl)")

                                finishLoading()
//                                showShareSheet = true

                            } catch {
                                finishLoading()
                                print(error.localizedDescription)
                            }
                        }
                    }

            },
            sheetSize: .fixed(436)
        )
    }
    
    func delete() {
        
    }
}
