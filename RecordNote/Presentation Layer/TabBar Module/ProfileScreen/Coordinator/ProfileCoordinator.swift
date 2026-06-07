//
//  ProfileCoordinator.swift
//  RecordNote
//
//  Created Mohamed Ali on 03/06/2026.
//

import UIKit

final class ProfileCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    
    private let title = ""
    private let imgName: UIImage = .unSelectedProfile
    private let selectedimgName: UIImage = .selectedProfile

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    override func start() {
        let viewModel      = ProfileViewModel(coordinator: self, useCase: ProfileUseCases(respotery: HomeRespository(realm: RealmStorage(), local: LocalStorage())))
        let viewController = ProfileViewController(viewModel: viewModel)
        viewController.tabBarItem = UITabBarItem(title: title, image: imgName, selectedImage: selectedimgName)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func moveToLoginScreen() {
        let coordinator = LoginCoordinator(navigationController: navigationController)
        add(coordinator: coordinator)
        coordinator.start()
    }
}
