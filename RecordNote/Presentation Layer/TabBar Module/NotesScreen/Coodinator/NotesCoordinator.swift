//
//  NotesCoordinator.swift
//  RecordNote
//
//  Created Mohamed Ali on 03/06/2026.
//

import UIKit

final class NotesCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    
    private let title = ""
    private let imgName: UIImage = .unSelectedNotes
    private let selectedimgName: UIImage = .selectedNotes

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    override func start() {
        let viewModel      = NotesViewModel(coordinator: self)
        let viewController = NotesViewController(viewModel: viewModel)
        viewController.tabBarItem = UITabBarItem(title: title, image: imgName, selectedImage: selectedimgName)
        navigationController.pushViewController(viewController, animated: true)
    }
}
