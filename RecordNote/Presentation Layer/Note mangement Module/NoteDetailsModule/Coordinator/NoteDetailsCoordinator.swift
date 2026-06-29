//
//  NoteDetailsCoordinator.swift
//  RecordNote
//
//  Created Mohamed Ali on 11/06/2026.
//

import UIKit

protocol NoteDetailsCoordinatorDelegate: AnyObject {
    func noteDetailsCoordinatorDidRequestRefresh(_ coordinator: NoteDetailsCoordinator)
}

final class NoteDetailsCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    let note: NoteRealModelInfoModel
    private let sheetManager = CustomSheetManager()
    weak var delegate: NoteDetailsCoordinatorDelegate?

    init(
        navigationController: UINavigationController,
        note: NoteRealModelInfoModel,
        delegate: NoteDetailsCoordinatorDelegate? = nil
    ) {
        self.navigationController = navigationController
        self.note = note
        self.delegate = delegate
    }

    override func start() {
        let viewModel = NoteDetailsViewModel(
            coordinator: self,
            noteModel: note,
            useCases: NoteDetailsUseCases(respotery: NotesRespotery(realm: RealmStorage()), service: PDFExportService()),
            sheetManager: sheetManager
        )
        let viewController = NoteDetailsViewController(
            viewModel: viewModel,
            sheetManager: sheetManager
        )

        navigationController.pushViewController(viewController, animated: true)
    }
    
    func dismissToParentScreen(shouldRefresh: Bool = false) {
        if shouldRefresh {
            delegate?.noteDetailsCoordinatorDidRequestRefresh(self)
        }

        removeFromParant()
        navigationController.popViewController(animated: true)
    }
    
    func moveToEditNoteScreen() {
        let coordinator = EditNoteCoordinator(navigationController: navigationController, note: note)
        add(coordinator: coordinator)
        coordinator.start()
    }
}
