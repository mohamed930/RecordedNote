//
//  LoginViewModel.swift
//  RecordNote
//
//  Created by Mohamed Ali on 26/05/2026.
//

import SwiftUI
import Combine

class LoginViewModel: NSObject, ObservableObject {
    
    var coordinator: LoginCoordinator
    
    init(coordinator: LoginCoordinator) {
        self.coordinator = coordinator
    }
}
