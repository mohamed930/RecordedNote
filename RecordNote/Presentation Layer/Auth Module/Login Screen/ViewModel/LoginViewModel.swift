//
//  LoginViewModel.swift
//  RecordNote
//
//  Created by Mohamed Ali on 26/05/2026.
//

import SwiftUI
import Combine
import IQKeyboardManagerSwift

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
    private var useCases: AuthUseCase
    
    init(coordinator: LoginCoordinator,useCases: AuthUseCase) {
        self.coordinator = coordinator
        self.useCases = useCases
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
    
    func loginButtonAction() async {
        
        IQKeyboardManager.shared.resignFirstResponder()
        
        isloading = true
        
        do {
            let response = try await useCases.login(email: emailAddress, password: password)
            
            isloading = false
            
            if response {
                errorFlag = false
                
                // MARK: - TODO: - move to TabBar.
                
            }
            else {
                errorFlag = true
            }
            
        } catch {
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
