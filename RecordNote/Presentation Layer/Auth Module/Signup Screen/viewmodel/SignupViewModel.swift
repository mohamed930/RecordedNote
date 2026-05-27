//
//  SignupViewModel.swift
//  RecordNote
//
//  Created by Mohamed Ali on 27/05/2026.
//

import Foundation
import Combine

class SignupViewModel: NSObject, ObservableObject {
    
    // MARK: - Publishers.
    @Published var fullName: String = ""
    @Published var emailAddress: String = ""
    @Published var emailValidation: Bool = true
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isSaved: Bool = false
    @Published var isloading: Bool = false
    @Published var errorFlag: Bool = false
    
    // MARK: - validation.
    var isButtonEnabled: Bool {
        return !fullName.isEmpty &&
               !emailAddress.isEmpty &&
               !password.isEmpty &&
               !confirmPassword.isEmpty &&
               (password == confirmPassword) &&
                emailValidation &&
                isSaved
    }
    
    // MARK: - Coordinators
    var coordinator: SignupCoordinator
    
    init(coordinator: SignupCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Actions.
    func moveToLoginScreen() {
        coordinator.moveToLoginScreen()
    }
    
    func handleValidation() {
        emailValidation = DIContainer.shared.checkMailValidation(emailAddress: emailAddress)
    }
    
    func agreeConditionsAndTerms() {
        isSaved.toggle()
    }
    
    func signUpOperation() {
        isloading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self else { return }
            
            isloading = false
            errorFlag = true
        }
    }
    
    func signUpWithGoogleAction() {
        
    }
    
    func signUpWithAppleAction() {
        
    }
}
