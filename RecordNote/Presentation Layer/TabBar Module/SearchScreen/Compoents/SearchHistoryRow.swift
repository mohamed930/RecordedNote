//
//  SearchHistoryRow.swift
//  RecordNote
//
//  Created by Mohamed Ali on 14/06/2026.
//


import SwiftUI

struct SearchHistoryRow: View {

    let title: String
    var onTap: (() -> Void)?

    var body: some View {
        Button {
            onTap?()
        } label: {
            HStack(spacing: 12) {

                Image(systemName: "clock")
                    .font(.system(size: 15))
                    .foregroundStyle(.gray)

                Text(title)
                    .setFont(fontName: .mainFontMeduim, size: 15)
                    .foregroundStyle(.primary)
                    .padding(.bottom,2)
                    .foregroundStyle(Color._374151)

                Spacer()
            }
            .padding(.horizontal, 20)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.F_9_FAFB))
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SearchHistoryRow(title: "AI integration")
}
