//
//  NewNoteViewModel.swift
//  RecordNote
//
//  Created Mohamed Ali on 03/06/2026.
//

import Foundation
import Combine

final class NewNoteViewModel: ObservableObject {
    private weak var coordinator: NewNoteCoordinator?

    init(coordinator: NewNoteCoordinator) {
        self.coordinator = coordinator
    }
}