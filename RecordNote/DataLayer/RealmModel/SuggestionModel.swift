//
//  SuggestionModel.swift
//  RecordNote
//
//  Created by Mohamed Ali on 14/06/2026.
//

import Foundation
import RealmSwift

class SuggestionModel: Object {
    
    @Persisted(primaryKey: true)
    var id: String = UUID().uuidString
    
    @Persisted
    var suggest: String = ""
    
    func convertToString() -> String {
        return suggest
    }
}
