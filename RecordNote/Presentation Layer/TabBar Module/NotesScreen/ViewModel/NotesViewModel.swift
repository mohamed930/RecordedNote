//
//  NotesViewModel.swift
//  RecordNote
//
//  Created Mohamed Ali on 03/06/2026.
//

import Foundation
import Combine

final class NotesViewModel: ObservableObject {
    private weak var coordinator: NotesCoordinator?

    init(coordinator: NotesCoordinator) {
        self.coordinator = coordinator
    }
}