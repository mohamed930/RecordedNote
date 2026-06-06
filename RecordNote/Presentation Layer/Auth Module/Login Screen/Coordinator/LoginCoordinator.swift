//
//  LoginCoordinator.swift
//  RecordNote
//
//  Created by Mohamed Ali on 26/05/2026.
//

import UIKit

class LoginCoordinator: BaseCoordinator {
    let navigationController: UINavigationController
        
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let viewmodel = LoginViewModel(coordinator: self, useCases: AuthUseCase(repository: AuthRepository(service: AuthAPI())))
        let viewControlller = LoginViewController(viewModel: viewmodel)
        viewControlller.hidesBottomBarWhenPushed = true
        navigationController.setViewControllers([viewControlller], animated: true)
    }
    
    func moveToSignUpScreen() {
        let coordinator = SignupCoordinator(navigationController: navigationController)
        add(coordinator: coordinator)
        coordinator.start()
    }
    
    func moveToTabBarScreen() {
        let coordinator = TabBarCoordinator(navigationController: navigationController)
        add(coordinator: coordinator)
        coordinator.start()
    }
}
