//
//  SearchFiltersSection.swift
//  RecordNote
//
//  Created by Mohamed Ali on 14/06/2026.
//


import SwiftUI

struct SearchFiltersSection: View {

    @Binding var selectedDate: String
    @Binding var selectedCategory: String
    @Binding var hasTasks: Bool

    var onDateTap: (() -> Void)?
    var onCategoryTap: (() -> Void)?
    var onApply: (() -> Void)?

    @State private var isExpanded = true

    var body: some View {
        VStack(spacing: 0) {

            header

            if isExpanded {
                content
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .top)
                                .combined(with: .opacity),
                            removal: .opacity
                        )
                    )
            }
        }
        .padding(.horizontal,12)
        .background(Color(.systemBackground))
        .animation(.easeInOut(duration: 0.25), value: isExpanded)
    }
}

// MARK: - Header

private extension SearchFiltersSection {

    var header: some View {
        HStack(spacing: 12) {

            Image(systemName: "line.3.horizontal.decrease")
                .font(.title3)
                .foregroundStyle(.secondary)

            Text("Filters")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.primary)

            Spacer()

            Image(systemName: "chevron.up")
                .font(.headline)
                .foregroundStyle(.secondary)
                .rotationEffect(
                    .degrees(isExpanded ? 0 : 180)
                )
        }
        .contentShape(Rectangle()) // entire area becomes tappable
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.5)) {
                isExpanded.toggle()
            }
        }
    }

    var content: some View {
        VStack(spacing: 0) {

            filterRow(
                title: "Date",
                value: selectedDate,
                action: onDateTap
            )
            .padding(.bottom,-10)

            Divider()
                .padding(.bottom,-10)

            filterRow(
                title: "Category",
                value: selectedCategory,
                action: onCategoryTap
            )
            .padding(.bottom,-10)

            Divider()
                .padding(.bottom,-10)

            HStack {
                Text("Has Tasks")
                    .setFont(fontName: .mainFontMeduim, size: 16)

                Spacer()

                Toggle("", isOn: $hasTasks)
                    .labelsHidden()
            }
            .padding(.vertical, 24)
            .padding(.bottom,-10)

            Button {
                onApply?()
            } label: {
                Text("Apply Filters")
                    .setFont(fontName: .mainFontBold, size: 16)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        LinearGradient(
                            colors: [
                                Color.A_78_BFA.opacity(0.955),
                                Color.A_78_BFA
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(
                        RoundedRectangle(cornerRadius: 16)
                    )
            }
            .padding(.top, 12)
        }
        .padding(.top, 12)
    }

    func filterRow(
        title: String,
        value: String,
        action: (() -> Void)?
    ) -> some View {
        Button {
            action?()
        } label: {
            HStack {

                Text(title)
                    .setFont(fontName: .mainFontMeduim, size: 16)
                    .foregroundStyle(.primary)

                Spacer()

                HStack(spacing: 8) {
                    Text(value)
                        .setFont(fontName: .mainFontSemiBold, size: 16)
                        .foregroundStyle(.A_78_BFA)

                    Image(systemName: "chevron.down")
                        .setFont(fontName: .mainFontSemiBold, size: 14)
                        .foregroundStyle(.A_78_BFA)
                }
            }
            .padding(.vertical, 24)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    @State var selectedDate = "All Time"
    @State var selectedCategory = "All"
    @State var hasTasks = false

    SearchFiltersSection(
        selectedDate: $selectedDate,
        selectedCategory: $selectedCategory,
        hasTasks: $hasTasks
    )
    .padding()
}
