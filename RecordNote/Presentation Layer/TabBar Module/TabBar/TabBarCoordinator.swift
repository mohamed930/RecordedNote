//
//  TabBarCoordinator.swift
//  customTabBar
//
//  Created by Mohamed Ali on 09/03/2024.
//

import UIKit

class TabBarCoordinator: BaseCoordinator {
    // MARK: TODO: variables:
    var navigationController: UINavigationController
    
    var selectedIndex: Int
        
            
    init(navigationController: UINavigationController,selectedIndex: Int = 0) {
        self.navigationController = navigationController
        self.selectedIndex = selectedIndex
    }

    
    override func start() {
        let tabBar = CustomTabBarController()
        tabBar.coordinator = self
        tabBar.tabIndex = selectedIndex
        
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        guard window?.rootViewController is UINavigationController else {
            navigationController.isNavigationBarHidden = true
            navigationController.setViewControllers([tabBar], animated: true)
            
            return
        }
        
        let navi = UINavigationController(rootViewController: tabBar)
        navigationController = navi
        navigationController.isNavigationBarHidden = true
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    
    func moveToRecordScreen() {
        let coordinator = NewNoteCoordinator(navigationController: navigationController)
        add(coordinator: coordinator)
        coordinator.start()
    }
}
