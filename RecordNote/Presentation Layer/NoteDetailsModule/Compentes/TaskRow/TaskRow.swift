//
//  TaskRow.swift
//  RecordNote
//
//  Created by Mohamed Ali on 11/06/2026.
//

import SwiftUI

struct TaskRow: View {

    let title: String
    let isDone: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {

                Checkbox(isChecked: isDone)

                Text(title)
                    .foregroundColor(
                        isDone
                        ? Color._99_A_1_AF
                        : Color.primary
                    )
                    .strikethrough(isDone)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .setFont(fontName: .mainFontSemiBold, size: 16)
            }
            .padding(.vertical, 20)
        }
        .buttonStyle(.plain)
    }
}
