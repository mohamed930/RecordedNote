//
//  NewNoteCoordinator.swift
//  RecordNote
//
//  Created Mohamed Ali on 03/06/2026.
//

import UIKit

final class NewNoteCoordinator: BaseCoordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
    }

    override func start() {
        let viewModel = NewNoteViewModel(coordinator: self)
        let viewController = NewNoteViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: true)
    }
}
