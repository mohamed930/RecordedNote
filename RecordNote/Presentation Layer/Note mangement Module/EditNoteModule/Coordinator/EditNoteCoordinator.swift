//
//  EditNoteCoordinator.swift
//  RecordNote
//
//  Created by Mohamed Ali on 29/06/2026.
//

import UIKit

class EditNoteCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    let note: NoteRealModelInfoModel

    init(
        navigationController: UINavigationController,
        note: NoteRealModelInfoModel,
    ) {
        self.navigationController = navigationController
        self.note = note
    }
    
    override func start() {
        let viewModel = EditNoteViewModel(coordinator: self, noteModel: note)
        let viewController = EditNoteViewController(viewModel: viewModel)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func moveToNoteDetailsScreen() {
        navigationController.popViewController(animated: true)
    }
}
