//
//  HomeView.swift
//  RecordNote
//
//  Created Mohamed Ali on 03/06/2026.
//

import SwiftUI

// MARK: - HomeView

struct HomeView: View {

    // MARK:- Private
    @ObservedObject private var viewModel: HomeViewModel

    init(viewModel: HomeViewModel) {
      self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            Text("Home")
        }
    }
}

#Preview {
    HomeView(
        viewModel: HomeViewModel(coordinator: HomeCoordinator(navigationController: UINavigationController()))
    )
}
