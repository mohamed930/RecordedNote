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
                    .padding(.bottom, 10)
                
                List {
                    ForEach(viewModel.latestSearchResult, id: \.id) { note in
                        SearchHistoryRow(title: note.suggest) {
                            viewModel.suggestionTappedAction(title: note.suggest)
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .padding(.vertical, 4)
                        .swipeActions(edge: .trailing) {
                            Button(role: .cancel) {
                                viewModel.deleteSuggestion(note)
                            } label: {
                                Image(systemName: "trash")
                            }
                            .tint(.red)
                        }
                    }
                }
                .listStyle(.plain)
                .frame(maxHeight: CGFloat(viewModel.latestSearchResult.count) * 58)
                .background(Color.clear)
                .environment(\.defaultMinListRowHeight, 0)
                .disableScrollIfAvailable()
                .onAppear {
                    UITableView.appearance().separatorStyle = .none
                }
                .padding(.bottom,16)
            }
            
            ScrollView {
                SearchFiltersSection(
                    selectedDate: $viewModel.date,
                    selectedCategory: $viewModel.category,
                    selectedDates: $viewModel.selectedDates,
                    onCategoryTap: { str in
                        viewModel.filterCategpry = str
                        viewModel.category = str
                    },
                    onApply: {
                        viewModel.searchWithFilter()
                    }
                )
                .padding(.bottom,16)
                
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.results) { note in
                        MeetingNoteCard(note: note)
                            .onTapGesture {
                                viewModel.moveToNoteDetailsScreen(note: note)
                            }
                    }
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal,16)
        .onAppear {
            viewModel.latestSearchResult = viewModel.useCases.fetchSuggestion()
            UITableView.appearance().separatorStyle = .none
            UITableView.appearance().backgroundColor = .clear
        }
    }
}

#Preview {
    SearchView(
        viewModel: SearchViewModel(coordinator: SearchCoordinator(navigationController: UINavigationController()), useCases: SearchUseCases(respotery: SearchResportry(realm: RealmStorage())))
    )
}

extension View {
    
    @ViewBuilder
    func disableScrollIfAvailable() -> some View {
        if #available(iOS 16.0, *) {
            self.scrollDisabled(true)
        } else {
            self
        }
    }
}
