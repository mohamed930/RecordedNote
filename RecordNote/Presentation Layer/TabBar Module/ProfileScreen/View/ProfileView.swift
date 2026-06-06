//
//  ProfileView.swift
//  RecordNote
//
//  Created Mohamed Ali on 03/06/2026.
//

import SwiftUI

// MARK: - ProfileView

struct ProfileView: View {

    // MARK:- Private
    @ObservedObject private var viewModel: ProfileViewModel

    init(viewModel: ProfileViewModel) {
      self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            Text("Profile view")
        }
    }
}

#Preview {
    ProfileView(
        viewModel: ProfileViewModel(coordinator: ProfileCoordinator(navigationController: UINavigationController()))
    )
}
