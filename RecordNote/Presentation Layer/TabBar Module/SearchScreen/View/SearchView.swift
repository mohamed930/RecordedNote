//
//  SearchView.swift
//  RecordNote
//
//  Created Mohamed Ali on 03/06/2026.
//

import SwiftUI

// MARK: - SearchView

struct SearchView: View {

    // MARK:- Private
    @ObservedObject private var viewModel: SearchViewModel

    init(viewModel: SearchViewModel) {
      self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            Text("Search view")
        }
    }
}

#Preview {
    SearchView(
        viewModel: SearchViewModel(coordinator: SearchCoordinator(navigationController: UINavigationController()))
    )
}
