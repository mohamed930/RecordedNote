//
//  sharedProtocol.swift
//  LNJ-Daftar
//
//  Created by Mohamed Ali on 21/02/2024.
//

import Foundation

enum Language {
    case arabic
    case english
}

protocol SharedProtocol {
    func fetchAppLanguage() -> Language
}

class SharedLanguage: SharedProtocol {
    static var shared = SharedLanguage()
}

extension SharedProtocol {
    func fetchAppLanguage() -> Language {
        
        let localstorage: LocalStorageProtocol = LocalStorage()
        
        let pre = Locale.preferredLanguages[0]
        
        let preCorrectLanguage: [String] = pre.components(separatedBy: "-")
        
        let systemLanguage: Language!
        
        if preCorrectLanguage[0] == "en" {
            systemLanguage = .english
        }
        else {
            systemLanguage = .arabic
        }
        
        guard let langugage: [String] = localstorage.value(key: LocalStorageKeys.appleLanguages) else { return systemLanguage }
                
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
