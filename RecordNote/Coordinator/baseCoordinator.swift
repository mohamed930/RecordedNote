//
//  baseCoordinator.swift
//  lnj_B2c
//
//  Created by Mohamed Ali on 12/10/2023.
//

import UIKit

class BaseCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var parantCoordinator: BaseCoordinator?
    
    func start() {
        fatalError("Children shoud implement 'start'")
    }
    
    func removeFromParant() {
        parantCoordinator?.remove(coordinator: self)
    }
    
    func removeAllCoordinators() {
        childCoordinators.removeAll()
    }
}
