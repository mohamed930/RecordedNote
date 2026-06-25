//
//  PDFPageBuilder.swift
//  RecordNote
//
//  Created by Mohamed Ali on 23/06/2026.
//

import Foundation

struct PDFPageContent {
    let transcriptParagraphs: [String]
}

extension String {

    func pdfParagraphs() -> [String] {
        components(separatedBy: "\n\n")
            .map {
                $0.trimmingCharacters(
                    in: .whitespacesAndNewlines
                )
            }
            .filter {
                !$0.isEmpty
            }
    }
}

struct PDFPageBuilder {

    static func transcriptChunks(
        from transcript: String,
        paragraphsPerPage: Int = 6
    ) -> [PDFPageContent] {

        let paragraphs = transcript.pdfParagraphs()

        return stride(
            from: 0,
            to: paragraphs.count,
            by: paragraphsPerPage
        ).map { startIndex in

            let endIndex = min(
                startIndex + paragraphsPerPage,
                paragraphs.count
            )

            return PDFPageContent(
                transcriptParagraphs: Array(
                    paragraphs[startIndex..<endIndex]
                )
            )
        }
    }
}
