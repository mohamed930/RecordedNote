//
//  NotesFilterView.swift
//  RecordNote
//
//  Created by Mohamed Ali on 07/06/2026.
//


import SwiftUI

struct NotesFilterView: View {

    @Binding var selectedFilter: NotesFilterValues

    var body: some View {
        HStack(spacing: 4) {
            ForEach(NotesFilterValues.allCases) { filter in
                Button {
                    selectedFilter = filter
                } label: {
                    Text(filter.rawValue)
                        .setFont(fontName: .mainFontMeduim, size: 13)
                        .foregroundStyle(
                            selectedFilter == filter
                            ? .white
                            : Color._6_A_7282
                        )
                        .padding(.horizontal, 20)
                        .frame(height: 36)
                        .background(
                            Capsule()
                                .fill(
                                    selectedFilter == filter
                                    ? Color.A_78_BFA
                                    : Color.F_3_F_4_F_6
                                )
                        )
                }
                .buttonStyle(.plain)
            }
            
            Spacer()
        }
    }
}

#Preview {
    NotesFilterView(selectedFilter: .constant(.all))
}
