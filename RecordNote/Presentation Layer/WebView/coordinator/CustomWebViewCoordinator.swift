//
//  CustomWebViewCoordinator.swift
//  RecordNote
//
//  Created by Mohamed Ali on 29/05/2026.
//

import UIKit

class CustomWebViewCoordinator: BaseCoordinator {
    let navigationController: UINavigationController
    let link: String
    let title: String
        
    init(navigationController: UINavigationController,link: String,title: String) {
        self.navigationController = navigationController
        self.link = link
        self.title = title
    }
    
    override func start() {
        let viewmodel = CustomWebViewModel(coordinator: self, link: link, title: title)
        let viewController = CustomWebViewViewController(viewModel: viewmodel)
        viewController.isModalInPresentation = true
        navigationController.topViewController?.present(
            viewController,
            animated: true
        )
    }
    
    func moveToRootScreen() {
        navigationController.topViewController?.dismiss(animated: true)
    }
}
