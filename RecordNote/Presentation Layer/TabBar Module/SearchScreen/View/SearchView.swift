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
        VStack(alignment: .leading,spacing: 0) {
            Text("Search")
                .setFont(fontName: .mainFontBold, size: 26)
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding(.bottom,14)
            
            SearchTextField(
                text: $viewModel.searchText,
                onDebounce: {
                    viewModel.search()
                },
                onSearch: {
                    viewModel.search()
                }
            )
            .padding(.bottom,16)
            
            if !viewModel.latestSearchResult.isEmpty {
                Text("Recent Searches")
                    .setFont(fontName: .mainFontSemiBold, size: 14)
                    .foregroundStyle(Color._99_A_1_AF)
                    .padding(.bottom,10)
                
                LazyVStack(spacing: 6) {
                    ForEach(
                        Array(viewModel.latestSearchResult.enumerated()),
                        id: \.offset
                    ) { _, note in
                        SearchHistoryRow(title: note) {
                            viewModel.suggestionTappedAction(title: note)
                        }
                    }
                }
                .padding(.bottom,20)
            }
            
            ScrollView {
                SearchFiltersSection(
                    selectedDate: $viewModel.date,
                    selectedCategory: $viewModel.category,
                    onDateTap: {
                        
                    },
                    onCategoryTap: {
                        
                    },
                    onApply: {
                        
                    }
                )
                .padding(.bottom,16)
                
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.results) { note in
                        MeetingNoteCard(note: note)
                    }
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal,16)
        .onAppear {
            viewModel.latestSearchResult = viewModel.useCases.fetchSuggestion()
        }
    }
}

#Preview {
    SearchView(
        viewModel: SearchViewModel(coordinator: SearchCoordinator(navigationController: UINavigationController()), useCases: SearchUseCases(respotery: SearchResportry(realm: RealmStorage())))
    )
}
