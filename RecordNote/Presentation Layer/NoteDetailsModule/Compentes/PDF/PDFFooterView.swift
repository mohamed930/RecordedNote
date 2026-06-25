//
//  PDFFooterView.swift
//  RecordNote
//
//  Created by Mohamed Ali on 23/06/2026.
//

import SwiftUI

struct PDFFooterView: View {

    let currentPage: Int
    let totalPages: Int

    var body: some View {

        HStack {

            Text("This document was generated using RecordNote.")
                .font(.caption)
                .foregroundStyle(.secondary)

            Spacer()

            Text("Page \(currentPage) of \(totalPages)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
