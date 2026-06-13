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
        let allNotes: [NoteRealModelInfoModel] = realm.objects()
        
        let noteDTo = allNotes.prefix(5).map({ $0.convertToDTO() })
        
        return noteDTo
    }
    
    func fetchUserName() -> String? {
        let userName: String? = local.value(key: LocalStorageKeys.fullName)
        return userName
    }
    
    func fetchEmail() -> String? {
        let email: String? = local.value(key: LocalStorageKeys.email)
        return email
    }
    
    func deleteUser() -> Bool {
        local.remove(key: LocalStorageKeys.fullName)
        local.remove(key: LocalStorageKeys.appleEmail)
        local.remove(key: LocalStorageKeys.userGoogle)
        local.remove(key: LocalStorageKeys.firstTime)
        
        return true
    }
    
    func fetchNotesSavedSize() -> String {
        let notes: [NoteRealModelInfoModel] = realm.objects()

        let totalBytes = notes.reduce(0) { result, note in
            let textBytes =
                note.name.utf8.count +
                note.summary.utf8.count +
                note.transcript.utf8.count

            let audioBytes = note.audio?.count ?? 0

            return result + textBytes + audioBytes
        }

        let formatted = ByteCountFormatter.string(
            fromByteCount: Int64(totalBytes),
            countStyle: .file
        )
        
        return formatted
    }
}
