//
//  HomeViewModel.swift
//  RecordNote
//
//  Created Mohamed Ali on 03/06/2026.
//

import Foundation
import Combine
import SwiftUI

final class HomeViewModel: ObservableObject {
    private weak var coordinator: HomeCoordinator?
    
    @Published var userName: String = "Mohamed Ali"
    
    @Published var notes: [MeetingNote] = [
                                                .init(
                                                    title: "Project Meeting Notes",
                                                    date: Date(),
                                                    indicatorColor: .purple
                                                ),
                                                .init(
                                                    title: "Sprint Planning",
                                                    date: Date().addingTimeInterval(3600),
                                                    indicatorColor: .blue
                                                )
                                            ]

    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
        
    }
    
    // MARK: - Actions.
    func recordNoteButtonAction() {
        
    }
    
    func seeAllButtonAction() {
        
    }
}
