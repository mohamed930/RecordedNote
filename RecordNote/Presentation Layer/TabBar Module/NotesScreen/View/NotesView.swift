//
//  NotesView.swift
//  RecordNote
//
//  Created Mohamed Ali on 03/06/2026.
//

import SwiftUI

// MARK: - NotesView

struct NotesView: View {

    // MARK:- Private
    @ObservedObject private var viewModel: NotesViewModel

    init(viewModel: NotesViewModel) {
      self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            Text("Notes view")
        }
    }
}

#Preview {
    NotesView(
        viewModel: NotesViewModel(coordinator: NotesCoordinator(navigationController: UINavigationController()))
    )
}
