//
//  SearchBarView.swift
//  RecordNote
//
//  Created by Mohamed Ali on 14/06/2026.
//


import SwiftUI
import IQKeyboardManagerSwift

struct SearchTextField: View {

    @Environment(\.dismiss) private var dismiss

    @Binding var text: String

    var placeholder: String = "Search notes, tasks, keywords..."
    var debounceDuration: TimeInterval = 0.5

    var onDebounce: (() -> Void)?
    var onSearch: (() -> Void)?

    @State private var debounceTask: DispatchWorkItem?

    var body: some View {
        HStack(spacing: 12) {

            searchField

            if !text.isEmpty {
                Button("Cancel") {
                    cancel()
                }
                .setFont(fontName: .mainFontMeduim, size: 16)
                .foregroundStyle(.A_78_BFA)
            }
            
           
        }
    }
}

// MARK: - Search Field

private extension SearchTextField {

    var searchField: some View {
        HStack(spacing: 12) {

            Image(systemName: "magnifyingglass")
                .foregroundStyle(.gray)

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
                        .foregroundStyle(.gray)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 43)
        .background(
            RoundedRectangle(cornerRadius: 12)
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
        debounceTask?.cancel()
        onSearch?()
    }

    func clear() {
        debounceTask?.cancel()
        text = ""
        onDebounce?()
    }

    func cancel() {
        debounceTask?.cancel()
        text = ""
        dismiss()
        IQKeyboardManager.shared.resignFirstResponder()
    }
}
