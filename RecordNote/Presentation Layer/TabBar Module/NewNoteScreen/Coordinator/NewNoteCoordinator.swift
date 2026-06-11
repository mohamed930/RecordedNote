//
//  NewNoteCoordinator.swift
//  RecordNote
//
//  Created Mohamed Ali on 03/06/2026.
//

import UIKit

final class NewNoteCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    var cameFromTabBar: Bool

    init(navigationController: UINavigationController,cameFromTabBar: Bool = true) {
        self.navigationController = navigationController
        self.cameFromTabBar = cameFromTabBar
        
    }

    override func start() {
        let viewModel = NewNoteViewModel(coordinator: self)
        let viewController = NewNoteViewController(viewModel: viewModel)
        if cameFromTabBar {
            navigationController.setViewControllers([viewController], animated: true)
        }
        else {
            viewController.hidesBottomBarWhenPushed = true
            navigationController.pushViewController(viewController, animated: true)
        }
    }
}
