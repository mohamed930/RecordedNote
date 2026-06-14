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
            
            Text("Recent Searches")
                .setFont(fontName: .mainFontSemiBold, size: 14)
                .foregroundStyle(Color._99_A_1_AF)
                .padding(.bottom,10)
            
            LazyVStack(spacing: 6) {
                ForEach(viewModel.latestSearchResult,id:\.id) { note in
                    SearchHistoryRow(title: note.name) {
                        viewModel.suggestionTappedAction(title: note.name)
                    }
                }
            }
            .padding(.bottom,20)
            
            ScrollView {
                SearchFiltersSection(
                    selectedDate: $viewModel.date,
                    selectedCategory: $viewModel.category,
                    hasTasks: $viewModel.hasTasks,
                    onDateTap: {
                        
                    },
                    onCategoryTap: {
                        
                    },
                    onApply: {
                        
                    }
                )
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal,16)
    }
}

#Preview {
    SearchView(
        viewModel: SearchViewModel(coordinator: SearchCoordinator(navigationController: UINavigationController()))
    )
}
