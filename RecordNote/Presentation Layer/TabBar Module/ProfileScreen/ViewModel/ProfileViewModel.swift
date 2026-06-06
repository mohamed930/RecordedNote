//
//  ProfileViewModel.swift
//  RecordNote
//
//  Created Mohamed Ali on 03/06/2026.
//

import Foundation
import Combine

final class ProfileViewModel: ObservableObject {
    private weak var coordinator: ProfileCoordinator?

    init(coordinator: ProfileCoordinator) {
        self.coordinator = coordinator
    }
}