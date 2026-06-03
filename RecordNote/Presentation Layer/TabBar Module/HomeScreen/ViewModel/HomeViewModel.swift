//
//  HomeViewModel.swift
//  RecordNote
//
//  Created Mohamed Ali on 03/06/2026.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    private weak var coordinator: HomeCoordinator?

    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
    }
}