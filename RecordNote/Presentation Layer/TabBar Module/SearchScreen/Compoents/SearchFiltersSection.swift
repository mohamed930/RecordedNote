//
//  SearchFiltersSection.swift
//  RecordNote
//
//  Created by Mohamed Ali on 14/06/2026.
//


import SwiftUI

enum FilterType {
    case multiDate
    case menu(values: [String])
}

struct FilterItem: Identifiable {
    let id = UUID()
    let title: String
    var value: String
    let type: FilterType
}

struct SearchFiltersSection: View {

    @Binding var selectedDate: String
    @Binding var selectedCategory: String
    @State private var isDateExpanded: Bool = false
    @Binding var selectedDates: Set<DateComponents>

    var onCategoryTap: ((String) -> Void)?
    var onApply: (() -> Void)?

    @State private var isExpanded = false

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
                type: .multiDate,
                action: { _ in
                    isDateExpanded.toggle()
                }
            )
            .padding(.bottom,10)
            
            if isDateExpanded {
                if #available(iOS 16.0, *) {
                    MultiDatePicker(
                        "Dates",
                        selection: $selectedDates
                    )
//                    .padding(.top, 8)
                    .frame(height: 310)
                    
                } else {
                    // Fallback on earlier versions
                }
            }

            Divider()
                .padding(.bottom,-10)

            filterRow(
                title: "Category",
                value: selectedCategory,
                type: .menu(
                    values: NotesFilterValues.allCases.map({ $0.rawValue })
                ),
                action: { str in
                    onCategoryTap?(str)
                }
            )
            .padding(.bottom,-6)
            
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

    @ViewBuilder
    func filterRow(
        title: String,
        value: String,
        type: FilterType,
        action: ((String) -> Void)?
    ) -> some View {

        switch type {

        case .multiDate:
            Button {
                action?("")
            } label: {
                rowContent(
                    title: title,
                    value: value
                )
            }
            .buttonStyle(.plain)

        case .menu(let values):
            Menu {
                ForEach(values, id: \.self) { item in
                    Button(item) {
                        action?(item)
                    }
                }
            } label: {
                rowContent(
                    title: title,
                    value: value
                )
            }
        }
    }
    
    func rowContent(
        title: String,
        value: String
    ) -> some View {

        HStack {

            Text(title)
                .setFont(
                    fontName: .mainFontMeduim,
                    size: 16
                )

            Spacer()

            HStack(spacing: 8) {

                Text(value)
                    .setFont(
                        fontName: .mainFontSemiBold,
                        size: 16
                    )
                    .foregroundStyle(.A_78_BFA)

                Image(systemName: "chevron.down")
                    .foregroundStyle(.A_78_BFA)
            }
        }
        .padding(.vertical, 24)
    }
}

#Preview {
    @State var selectedDate = "All Time"
    @State var selectedCategory = "All"

    SearchFiltersSection(
        selectedDate: $selectedDate,
        selectedCategory: $selectedCategory, selectedDates: .constant([])
    )
    .padding()
}
