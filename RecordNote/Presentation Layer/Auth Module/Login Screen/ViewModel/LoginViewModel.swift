//
//  LoginViewModel.swift
//  RecordNote
//
//  Created by Mohamed Ali on 26/05/2026.
//

import SwiftUI
import Combine

class LoginViewModel: NSObject, ObservableObject {
    
    // MARK: - Publishers
    @Published var emailAddress: String = ""
    @Published var password: String = ""
    @Published var emailValidation: Bool = true
    @Published var isSaved: Bool = false
    @Published var isloading: Bool = false
    @Published var errorFlag: Bool = false
    var isButtonEnabled: Bool {
        return  !emailAddress.isEmpty &&
                !password.isEmpty &&
                emailValidation
    }
    
    // MARK: - Coordinators
    var coordinator: LoginCoordinator
    
    init(coordinator: LoginCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Actions.
    func checkMailValidation() {
        emailValidation = DIContainer.shared.checkMailValidation(emailAddress: emailAddress)
    }
    
    func savedPasswordButtonAction() {
        isSaved.toggle()
    }
    
    func forgetPasswordButtonAction() {
        
    }
    
    func loginButtonAction() {
        isloading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self else { return }
            
            isloading = false
            errorFlag = true
        }
    }
    
    func loginWithGoogleAction() {
        
    }
    
    func loginWithAppleAction() {
        
    }
    
    func moveToSignUpButtonAction() {
        coordinator.moveToSignUpScreen()
    }
}
