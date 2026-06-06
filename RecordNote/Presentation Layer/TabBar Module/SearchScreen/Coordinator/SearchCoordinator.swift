//
//  SearchCoordinator.swift
//  RecordNote
//
//  Created Mohamed Ali on 03/06/2026.
//

import UIKit

final class SearchCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    
    private let title = ""
    private let imgName: UIImage = .unSelectedSearch
    private let selectedimgName: UIImage = .selectedSearch

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
    }

    override func start() {
        let viewModel      = SearchViewModel(coordinator: self)
        let viewController = SearchViewController(viewModel: viewModel)
        viewController.tabBarItem =  UITabBarItem(title: title, image: imgName, selectedImage: selectedimgName)
        navigationController.setViewControllers([viewController], animated: true)
    }
}
