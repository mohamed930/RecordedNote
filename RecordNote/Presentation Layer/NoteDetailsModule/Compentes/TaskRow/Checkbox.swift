//
//  Checkbox.swift
//  RecordNote
//
//  Created by Mohamed Ali on 11/06/2026.
//

import SwiftUI

struct Checkbox: View {

    let isChecked: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(isChecked ? Color._7_C_3_AED : .clear)
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(
                            isChecked
                            ? Color._7_C_3_AED
                            : Color.gray.opacity(0.4),
                            lineWidth: 2
                        )
                }

            if isChecked {
                Image(systemName: "checkmark")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .frame(width: 20, height: 20)
    }
}
