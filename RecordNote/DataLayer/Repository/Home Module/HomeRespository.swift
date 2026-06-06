//
//  HomeRespository.swift
//  RecordNote
//
//  Created by Mohamed Ali on 06/06/2026.
//

import Foundation

class HomeRespository: HomeRespositoryProtocol {
    
    private let realm: RealmStorage
    private let local: LocalStorage
    
    init(realm: RealmStorage,local: LocalStorage) {
        self.realm = realm
        self.local = local
    }
    
    func fetchNotes() -> [MeetingNote] {
        var allNotes: [NoteRealModelInfoModel] = realm.objects()
        
        var noteDTo = allNotes.prefix(5).map({ $0.convertToDTO() })
        
        return noteDTo
    }
    
    func fetchUserName() -> String? {
        let userName: String? = local.value(key: LocalStorageKeys.fullName)
        return userName
    }
    
}
