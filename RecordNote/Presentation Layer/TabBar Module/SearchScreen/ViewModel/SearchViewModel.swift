//
//  SearchViewModel.swift
//  RecordNote
//
//  Created Mohamed Ali on 03/06/2026.
//

import Foundation
import Combine

final class SearchViewModel: ObservableObject {
    private weak var coordinator: SearchCoordinator?

    init(coordinator: SearchCoordinator) {
        self.coordinator = coordinator
    }
}