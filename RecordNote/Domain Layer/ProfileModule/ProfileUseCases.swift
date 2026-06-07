//
//  ProfileUseCases.swift
//  RecordNote
//
//  Created by Mohamed Ali on 07/06/2026.
//

import Foundation

final class ProfileUseCases {
    
    private let respotery: HomeRespositoryProtocol
    
    init(respotery: HomeRespositoryProtocol) {
        self.respotery = respotery
    }
    
    func logoutOperation() -> Bool{
        return respotery.deleteUser()
    }
    
    func getUserName() -> String? {
        return respotery.fetchUserName()
    }
    
    func fetchEmail() -> String? {
        return respotery.fetchEmail()
    }
    
    func fetchSize() -> String {
        return respotery.fetchNotesSavedSize()
    }
}
