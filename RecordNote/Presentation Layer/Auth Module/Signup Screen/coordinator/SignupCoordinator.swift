//
//  SignupCoordinator.swift
//  RecordNote
//
//  Created by Mohamed Ali on 27/05/2026.
//

import UIKit

class SignupCoordinator: BaseCoordinator {
    let navigationController: UINavigationController
        
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let viewmodel = SignupViewModel(coordinator: self, useCases: AuthUseCase(repository: AuthRepository(service: AuthAPI())))
        let viewControlller = SignupViewController(viewModel: viewmodel)
        viewControlller.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewControlller, animated: true)
    }
    
    func moveToLoginScreen() {
        navigationController.popViewController(animated: true)
    }
}
