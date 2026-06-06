//
//  SignupViewModel.swift
//  RecordNote
//
//  Created by Mohamed Ali on 27/05/2026.
//

import Foundation
import Combine
import IQKeyboardManagerSwift

class SignupViewModel: NSObject, ObservableObject, ErrorProtocol {
    
    // MARK: - Publishers.
    @Published var fullName: String = ""
    @Published var emailAddress: String = ""
    @Published var emailValidation: Bool = true
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isSaved: Bool = false
    @Published var isloading: Bool = false
    @Published var errorFlag: Bool = false
    @Published var errorMessage: String = ""
    
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
    var useCases: AuthUseCase
    
    init(coordinator: SignupCoordinator,useCases: AuthUseCase) {
        self.coordinator = coordinator
        self.useCases = useCases
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
    
    func moveToTermsAndConditions() {
        coordinator.moveToTermsAndConditions(link: "https://www.google.com", title: "Terms of Service")
    }
    
    func moveToPrivacyPolicy() {
        coordinator.moveToTermsAndConditions(link: "https://www.twitch.tv", title: "Privacy Policy")
    }
    
    func signUpOperation() async {
        
        IQKeyboardManager.shared.resignFirstResponder()
        
        isloading = true
        
        do {
            let response = try await useCases.signup(name: fullName, email: emailAddress, password: password)
            
            isloading = false
            
            if response.isEmpty {
                errorFlag = false
                coordinator.moveToTabBarScreen()
            }
            else {
                errorMessage = response
                errorFlag = true
            }
            
        } catch {
            isloading = false
            
            let message: ErrorObjMessage = handleError(error)
            errorMessage = message.message
            errorFlag = true
        }
    }
    
    
    func signUpWithGoogleAction() async {
        do {
            let result = try await useCases.singUpGoogle()
            
            if result {
                errorFlag = false
                coordinator.moveToTabBarScreen()
            }
            else {
                errorFlag = true
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func signUpWithAppleAction() async {
        do {
            let result = try await useCases.singUpApple()
            
            if result {
                errorFlag = false
                coordinator.moveToTabBarScreen()
            }
            else {
                errorFlag = true
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
}
