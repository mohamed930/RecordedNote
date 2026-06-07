//
//  ProfileViewModel.swift
//  RecordNote
//
//  Created Mohamed Ali on 03/06/2026.
//

import Foundation
import Combine

final class ProfileViewModel: ObservableObject {
    private weak var coordinator: ProfileCoordinator?
    private var useCase: ProfileUseCases
    
    @Published var userName: String = ""
    @Published var email: String = ""
    @Published var recordSize: String = ""

    init(coordinator: ProfileCoordinator,useCase: ProfileUseCases) {
        self.coordinator = coordinator
        self.useCase = useCase
        
        fetchUserData()
    }
    
    // MARK: - Actions.
    func fetchUserData() {
        userName = useCase.getUserName() ?? "Mohamed Ali"
        email = useCase.fetchEmail() ?? "email"
        recordSize = useCase.fetchSize()
    }
    
    
    func logoutButtonAction() {
        if useCase.logoutOperation() {
            coordinator?.moveToLoginScreen()
        }
    }
}
