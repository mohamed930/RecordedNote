//
//  CustomTabBar.swift
//  customTabBar
//
//  Created by Mohamed Ali on 09/03/2024.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    var coordinator: TabBarCoordinator?
    
    var home         =  HomeCoordinator(navigationController: UINavigationController())
    var history      =  SearchCoordinator(navigationController: UINavigationController())
    var notification =  NotesCoordinator(navigationController: UINavigationController())
    var profile      =  ProfileCoordinator(navigationController: UINavigationController())
    
    var centerButton = UIButton(type: .custom)
    
    var tabIndex: Int! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Optional: Add a button in the center
        centerButton = UIButton(type: .custom)
//        let tabBarWidth = self.tabBar.frame.width
        let tabBarHeight = self.tabBar.frame.height
        let buttonSize: CGFloat = 56.0
        let yOffset = (tabBarHeight - buttonSize) / 2.0
        centerButton.frame = CGRect(x: (self.tabBar.frame.width - 56) / 2, y: yOffset, width: buttonSize, height: buttonSize)
        centerButton.setImage(UIImage.record, for: .normal)
        centerButton.addTarget(self, action: #selector(centerButtonTapped), for: .touchUpInside)
//        centerButton.layer.cornerRadius = 25.0

        self.tabBar.addSubview(centerButton)
        
        navigationController?.isNavigationBarHidden = true
        addChild(home.navigationController)
        home.start()

        addChild(history.navigationController)
        history.start()
        
        let viewController = EmptyViewController()
        // Create a tab bar item
        let tabBarItem = UITabBarItem()

        // Set the isEnabled property to false to make the tab item disabled
        tabBarItem.isEnabled = false
        
        viewController.tabBarItem  = tabBarItem
        
        
        addChild(notification.navigationController)
        notification.start()
        
        addChild(profile.navigationController)
        profile.start()
        
        viewControllers = [home.navigationController,history.navigationController,viewController,notification.navigationController,profile.navigationController]
        
        selectedIndex = tabIndex
        
        tabBar.tintColor = ._7_C_3_AED

        
    }

    @objc private func centerButtonTapped() {
        // Handle the center button tap event
        coordinator?.moveToRecordScreen()
    }
    
}



class EmptyViewController: UIViewController { }
