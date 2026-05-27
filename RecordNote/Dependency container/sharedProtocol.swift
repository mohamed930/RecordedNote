//
//  sharedProtocol.swift
//  LNJ-Daftar
//
//  Created by Mohamed Ali on 21/02/2024.
//

import Foundation

enum language {
    case arabic
    case english
}

protocol sharedProtocol {
    func fetchAppLanguage() -> language
}

class SharedLanguage: sharedProtocol {
    static var shared = SharedLanguage()
}

extension sharedProtocol {
    func fetchAppLanguage() -> language {
        
        let localstorage: LocalStorageProtocol = LocalStorage()
        
        let pre = Locale.preferredLanguages[0]
        
        let preCorrectLanguage: [String] = pre.components(separatedBy: "-")
        
        let systemLanguage: language!
        
        if preCorrectLanguage[0] == "en" {
            systemLanguage = .english
        }
        else {
            systemLanguage = .arabic
        }
        
        guard let langugage: [String] = localstorage.value(key: LocalStorageKeys.AppleLanguages) else { return systemLanguage }
                
        guard let pickedLang: String = langugage.first else { return systemLanguage }
                
        let correctlang: [String] = pickedLang.components(separatedBy: "-")
                
        guard let pickedLangWithoutType: String = correctlang.first else { return .arabic }
        
        if pickedLangWithoutType == "en" {
            return .english
        }
        else {
            return .arabic
        }
    }
}
