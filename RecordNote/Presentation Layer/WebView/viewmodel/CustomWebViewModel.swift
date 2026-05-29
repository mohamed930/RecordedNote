//
//  CustomWebViewModel.swift
//  RecordNote
//
//  Created by Mohamed Ali on 29/05/2026.
//

import Foundation
import Combine
import WebKit

class CustomWebViewModel: ObservableObject {
    
    // MARK: - Publishers.
    
    // MARK: - Dependancy.
    var coordinator: CustomWebViewCoordinator
    private var link: String
    var title: String
    
    init(coordinator: CustomWebViewCoordinator, link: String,title: String) {
        self.coordinator = coordinator
        self.link = link
        self.title = title
    }
    
    // MARK: - Actions.
    func makeURL() -> URL? {
        return URL(string: link)
    }
    
    func dismissButtonAction() {
        coordinator.moveToRootScreen()
    }
}
