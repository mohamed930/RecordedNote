//
//  AppCoordinator.swift
//  lnj_B2c
//
//  Created by Mohamed Ali on 12/10/2023.
//

import UIKit

final class AppCoordinator: BaseCoordinator {
    private let window: UIWindow?
        
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() {
        let navigationController = UINavigationController()
        
//        let coordinator = LoginCoordinator(navigationController: navigationController)
//        add(coordinator: coordinator)
//        coordinator.start()

        let coordinator = TabBarCoordinator(navigationController: navigationController)
        add(coordinator: coordinator)
        coordinator.start()
        
        guard let window = window else {
            return
        }

        navigationController.isNavigationBarHidden = true
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
