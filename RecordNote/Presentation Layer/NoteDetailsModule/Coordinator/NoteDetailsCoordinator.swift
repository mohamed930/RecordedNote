//
//  NoteDetailsCoordinator.swift
//  RecordNote
//
//  Created Mohamed Ali on 11/06/2026.
//

import UIKit

final class NoteDetailsCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    let note: NoteRealModelInfoModel

    init(navigationController: UINavigationController,note: NoteRealModelInfoModel) {
        self.navigationController = navigationController
        self.note = note
    }

    override func start() {
        let viewModel      = NoteDetailsViewModel(coordinator: self, noteModel: note, useCases: NoteDetailsUseCases(respotery: NotesRespotery(realm: RealmStorage())))
        let viewController = NoteDetailsViewController(viewModel: viewModel)
//        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func dismissToParentScreen() {
        navigationController.popViewController(animated: true)
    }
}
