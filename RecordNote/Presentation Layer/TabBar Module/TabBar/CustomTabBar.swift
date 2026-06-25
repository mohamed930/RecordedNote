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
        
        addTopBorder(color: .F_3_F_4_F_6, height: 1)
        
        // Optional: Add a button in the center
        centerButton = UIButton(type: .custom)
//        let tabBarWidth = self.tabBar.frame.width
        let tabBarHeight = self.tabBar.frame.height
        let buttonSize: CGFloat = 100.0
        let yOffset = (tabBarHeight - buttonSize) / 1.5
        centerButton.frame = CGRect(x: (self.tabBar.frame.width - 100) / 2, y: yOffset, width: buttonSize, height: buttonSize)
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
        tabBar.backgroundColor = .FAFAFA
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("CustomTabBarController disappeared")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("CustomTabBarController will disappear")
    }

    @objc private func centerButtonTapped() {
        // Handle the center button tap event
        coordinator?.moveToRecordScreen()
    }
    
    private func addTopBorder(color: UIColor, height: CGFloat) {
        // Create a custom layer that spans the full width of the screen
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: self.tabBar.frame.size.width, height: height)
        topBorder.backgroundColor = color.cgColor
        
        // Remove the default system shadow line to prevent overlap
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        
        // Add the new top border layer
        tabBar.layer.addSublayer(topBorder)
    }
    
}



class EmptyViewController: UIViewController { }
