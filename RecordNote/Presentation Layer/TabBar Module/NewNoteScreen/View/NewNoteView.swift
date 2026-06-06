//
//  NewNoteView.swift
//  RecordNote
//
//  Created Mohamed Ali on 03/06/2026.
//

import SwiftUI

// MARK: - NewNoteView

struct NewNoteView: View {

    // MARK:- Private
    @ObservedObject private var viewModel: NewNoteViewModel

    init(viewModel: NewNoteViewModel) {
      self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            Text("New Note Screen")
        }
    }
}

#Preview {
    NewNoteView(
        viewModel: NewNoteViewModel(coordinator: NewNoteCoordinator(navigationController: UINavigationController()))
    )
}
