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
        ZStack {
            Color.FAFAFA
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ZStack {
                    
                    Color.white
                    
                    Text("All Notes")
                        .setFont(fontName: .mainFontBold, size: 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal,16)
                }
                .frame(height: 53)
                .padding(.bottom,16)
                
                NotesFilterView(selectedFilter: $viewModel.selectedNoteFilters)
                    .padding(.horizontal,16)
                    .padding(.bottom,16)
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.notes,id: \.id) { note in
                            MeetingNoteCardComponets(attributes: note)
                        }
                    }
                    .padding(.horizontal, 12)
                }
                
                Spacer()
            }
        }
        .overlay(alignment: .bottomTrailing) {
            Button {
                viewModel.addButtonAction()
            } label: {
                Image(.addButton)
            }
//            .padding(.trailing, 12)
        }
    }
}

#Preview {
    NotesView(
        viewModel: NotesViewModel(coordinator: NotesCoordinator(navigationController: UINavigationController()))
    )
}
