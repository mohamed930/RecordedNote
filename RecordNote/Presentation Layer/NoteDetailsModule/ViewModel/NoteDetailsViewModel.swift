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

enum ActiveSheet {
    case pdfOptions
    case share(ShareItem)
}

final class NoteDetailsViewModel: ObservableObject {
    
    // MARK: - Published.
    @Published var category: String = "Meeting"
    @Published var noteModel: NoteRealModelInfoModel
    @Published var tasksList: [UITaskModel] = []
    @Published var selectedTab: NoteTab = .summary
    @Published var isMenuOpen: Bool = false
    @Published var audioTotalValue: String = "00:00"
    private var selectedTabs: [PDFContentOption] = []
    @Published var activeSheet: ActiveSheet?
    
    private weak var coordinator: NoteDetailsCoordinator?
    var useCases: NoteDetailsUseCases
    private let sheetManager: CustomSheetManager
    let audioPlayerViewModel: AudioPlayerViewModel
    private var cancellables = Set<AnyCancellable>()

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
        self.audioPlayerViewModel = AudioPlayerViewModel(
            useCases: NotesUseCases(
                notesRepository: NotesRespotery(realm: RealmStorage()),
                audioPlayer: AudioPlayerService()
            ),
            model: noteModel
        )
        
        tasksList = noteModel.tasks.map {
            return UITaskModel(title: $0.title, isDone: $0.isDone)
        }

        audioPlayerViewModel.$totalValue
            .receive(on: DispatchQueue.main)
            .sink { [weak self] totalValue in
                self?.audioTotalValue = totalValue
            }
            .store(in: &cancellables)
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
    func updatePDFOptions(_ selectedOptions: Set<PDFContentOption>) {
        selectedTabs = Array(selectedOptions)
    }
    
    func generatePDF(finishLoading: @escaping () -> Void) {
        let note = noteModel
        let duration = audioTotalValue
        let options = selectedTabs

        Task { [weak self] in
            guard let self else {
                await MainActor.run { finishLoading() }
                return
            }
            
            do {
                guard let pdfUrl = try await useCases.execute(
                    note: note,
                    duration: duration,
                    options: options
                ) else {
                    await MainActor.run { finishLoading() }
                    return
                }
                
                await MainActor.run {
                    finishLoading()
                    activeSheet = .share(
                        ShareItem(
                            id: note.id,
                            items: [pdfUrl]
                        )
                    )
                }
            } catch {
                await MainActor.run {
                    finishLoading()
                    print(error.localizedDescription)
                }
            }
        }
    }

    @MainActor
    func dismissActiveSheet() {
        activeSheet = nil
        sheetManager.dismiss()
    }
    
    @MainActor
    func savePdf() {
        isMenuOpen = false
        activeSheet = .pdfOptions

        sheetManager.present(sheetSize: .fixed(436))
    }
    
    func delete() {
        
    }
}
