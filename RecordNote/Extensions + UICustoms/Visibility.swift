//
//  Visibility.swift
//  RecordNote
//
//  Created by Mohamed Ali on 26/05/2026.
//


import SwiftUI

enum Visibility {
    case visible
    case invisible
    case gone
}

extension View {

    @ViewBuilder
    func visibility(_ visibility: Visibility) -> some View {

        switch visibility {

        case .visible:
            self

        case .invisible:
            self.hidden()

        case .gone:
            EmptyView()
        }
    }
}
