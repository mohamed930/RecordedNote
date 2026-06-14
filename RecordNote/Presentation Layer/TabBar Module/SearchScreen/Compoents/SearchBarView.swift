//
//  SearchBarView.swift
//  RecordNote
//
//  Created by Mohamed Ali on 14/06/2026.
//


import SwiftUI

struct SearchTextField: View {

    @Binding var text: String

    var placeholder: String = "Search notes, tasks, keywords..."
    var debounceDuration: TimeInterval = 0.5

    var onDebounce: (() -> Void)?
    var onSearch: (() -> Void)?

    @State private var debounceTask: DispatchWorkItem?

    var body: some View {
        HStack(spacing: 12) {

            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField(placeholder, text: $text)
                .submitLabel(.search)
                .onChange(of: text) { _ in
                    scheduleDebounce()
                }
                .onSubmit {
                    performSearch()
                }

            if !text.isEmpty {
                Button {
                    clear()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 56)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.systemGray6))
        )
    }
}

// MARK: - Actions

private extension SearchTextField {

    func scheduleDebounce() {
        debounceTask?.cancel()

        let task = DispatchWorkItem {
            onDebounce?()
        }

        debounceTask = task

        DispatchQueue.main.asyncAfter(
            deadline: .now() + debounceDuration,
            execute: task
        )
    }

    func performSearch() {
        // User pressed Search on keyboard
        // Cancel pending debounce to avoid duplicate requests
        debounceTask?.cancel()

        onSearch?()
    }

    func clear() {
        debounceTask?.cancel()

        text = ""

        onDebounce?()
    }
}
