//
//  NoteDetailsViewModel.swift
//  RecordNote
//
//  Created Mohamed Ali on 11/06/2026.
//

import SwiftUI
import Combine
import RealmSwift
import BottomSheet

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
    @Published var note: NoteRealModelInfoModel
    @Published var noteModel: NoteDTO
    @Published var tasksList: [UITaskModel] = []
    @Published var selectedTab: NoteTab = .summary
    @Published var isMenuOpen: Bool = false
    @Published var audioTotalValue: String = "00:00"
    private var selectedTabs: [PDFContentOption] = []
    @Published var shareItem: ShareItem?
    @Published var showAlert: Bool = false
    
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
        self.note = noteModel
        self.noteModel = noteModel.toDTO()
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
        let flag = useCases.updateTaskDetails(note: note, index: index, isDone: !note.tasks[index].isDone)
        
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
    
    private func moveToEditNoteDetails() {
        coordinator?.moveToEditNoteScreen()
    }
}

// MARK: - Menu action.
extension NoteDetailsViewModel {
    func edit() {
        isMenuOpen = false
        moveToEditNoteDetails()
    }
    
    func share() {
        isMenuOpen = false
        
        self.shareItem = ShareItem(id: noteModel.id, items: [note.shareText])
    }
    
    @MainActor
    func updatePDFOptions(_ selectedOptions: Set<PDFContentOption>) {
        selectedTabs = Array(selectedOptions)
    }
    
    func generatePDF(finishLoading: @escaping () -> Void) {
        let note = note
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
                
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    
                    finishLoading()
                    
                    sheetManager.onDismiss = { [weak self] in
                        guard let self else { return }
                        
                        print(sheetManager.position)
                        
                        self.shareItem = ShareItem(id: noteModel.id, items: [pdfUrl])
                        self.sheetManager.onDismiss = nil
                    }
                    
                    sheetManager.position = .hidden
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
    func savePdf() {
        isMenuOpen = false

        sheetManager.enableSwipeToDismiss = false
        sheetManager.position = .absolute(416)
    }
    
    func delete() {
        isMenuOpen = false
        showAlert = true
    }
    
    @MainActor
    func deleteOperation() {
        if useCases.deleteNote(note: note) {
            coordinator?.dismissToParentScreen(shouldRefresh: true)
        }
    }
}
