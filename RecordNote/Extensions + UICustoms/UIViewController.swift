//
//  UIViewController.swift
//  Masar
//
//  Created by Mohamed Ali on 16/10/2024.
//

import UIKit
//import RappleProgressHUD
import SwiftUI

extension UIViewController {
    
    func hideTabBar() {
        tabBarController?.tabBar.isHidden = true
        extendedLayoutIncludesOpaqueBars = true
    }
    
    func showTabBar() {
        tabBarController?.tabBar.isHidden = false
        extendedLayoutIncludesOpaqueBars = false
    }
    
//    func handleLoading(isloading: Bool) {
//        if isloading {
//            RappleActivityIndicatorView.startAnimatingWithLabel(L10n.pleaseWait, attributes: RappleModernAttributes)
//        }
//        else {
//            RappleActivityIndicatorView.stopAnimation()
//        }
//    }
    
    func showAlert(title: String,describition: String, completion: @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: describition, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { _ in
            completion()
        }))
        
        self.present(alert, animated: true)
    }
    
    func showAlert(title: String,describition: String) {
        let alert = UIAlertController(title: title, message: describition, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        
        self.present(alert, animated: true)
    }
    
    func showUnauthAlert(title: String,describition: String,completion: @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: describition, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel) { _ in
            completion()
        })
        
        self.present(alert, animated: true)
    }
    
    func showSuccessAlert(describition: String,completion: @escaping () -> ()) {
        let alert = UIAlertController(title: "Success", message: describition, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default,handler: { _ in
            completion()
        }))
        
        self.present(alert, animated: true)
    }
    
    func addHosting<Content: View>(_ swiftUI: Content) {
        
        self.view.backgroundColor = .white
            
        navigationController?.isNavigationBarHidden = true
        
        // Create a UIHostingController with the SwiftUI view
        let hostingController = UIHostingController(rootView: swiftUI)

        // Add the hosting controller as a child
        addChild(hostingController)
        view.addSubview(hostingController.view)

        // Set constraints
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        // Notify child
        hostingController.didMove(toParent: self)
    }
    
    func dismissScreen() {
        navigationController?.popViewController(animated: true)
    }
}

struct StoredUser {
        let userID: String
        let email: String
        let fullName: String
    }
    
    func storeUserInfo(userID: String, email: String, fullName: PersonNameComponents) {
        // Store the user's info in your backend or local database
        // For example, save user info in UserDefaults (for demonstration, NOT recommended for production)
        UserDefaults.standard.set(email, forKey: "\(userID)-email")
        UserDefaults.standard.set("\(fullName.givenName ?? "") \(fullName.familyName ?? "")", forKey: "\(userID)-fullName")
    }

func storeUserInfo(userID: String, email: String, fullName: String) {
    // Store the user's info in your backend or local database
    // For example, save user info in UserDefaults (for demonstration, NOT recommended for production)
    UserDefaults.standard.set(email, forKey: "\(userID)-email")
    UserDefaults.standard.set(fullName,forKey: "\(userID)-fullName")
}
    
    func fetchStoredUserInfo(userID: String) -> StoredUser? {
        if let email = UserDefaults.standard.string(forKey: "\(userID)-email"),
           let fullName = UserDefaults.standard.string(forKey: "\(userID)-fullName") {
            return StoredUser(userID: userID, email: email, fullName: fullName)
        }
        return nil
    }

extension UIViewController {
    func callPhoneNumber(_ phoneNumber: String) {
        let cleanedNumber = phoneNumber
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
        
        if let url = URL(string: "tel://\(cleanedNumber)"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
