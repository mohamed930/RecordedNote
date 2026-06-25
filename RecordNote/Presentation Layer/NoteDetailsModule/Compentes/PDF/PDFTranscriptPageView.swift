//
//  PDFTranscriptPageView.swift
//  RecordNote
//
//  Created by Mohamed Ali on 23/06/2026.
//

import SwiftUI

struct PDFTranscriptPageView: View {

    let noteTitle: String
    let exportDate: String
    let paragraphs: [String]
    let currentPage: Int
    let totalPages: Int

    var body: some View {

        VStack(alignment: .leading, spacing: 20) {

            transcriptHeader

            ForEach(
                paragraphs,
                id: \.self
            ) { paragraph in

                Text(paragraph)
                    .font(.body)
                    .foregroundStyle(.black)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
            }
            
            Spacer()
            
            PDFFooterView(currentPage: currentPage,
                          totalPages: totalPages)
        }
        .padding(24)
        .frame(
            width: 595.2,
            height: 841.8,
            alignment: .topLeading
        )
        .background(.white)
    }
}

private extension PDFTranscriptPageView {

    var transcriptHeader: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            
            HStack {
                Image(.recordAppNote)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)

                Text("RecordNote")
                    .font(.headline)
                    .fontWeight(.semibold)

                Spacer()

                Text(exportDate)
                    .font(.caption)
            }

            Divider()

            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 12) {
                    Circle()
                        .fill(.A_78_BFA)
                        .overlay {
                            Image(systemName: "mic")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        .frame(width: 40, height: 40)

                    Text("Transcript")
                        .setFont(fontName: .mainFontBold, size: 18)
                        .foregroundStyle(.A_78_BFA)
                }

                Divider()
                    .frame(height: 1.5)
                    .overlay(.A_78_BFA)
            }
        }
    }
}

#Preview {

    let chunks = PDFPageBuilder
        .transcriptChunks(
            from: NoteRealModelInfoModel
                .pcintMock
                .transcript
        )

    PDFTranscriptPageView(
        noteTitle: "Test",
        exportDate: "Today",
        paragraphs: chunks[0]
            .transcriptParagraphs,
        currentPage: 2,
        totalPages: 2
    )
    .scaleEffect(0.5)
}
