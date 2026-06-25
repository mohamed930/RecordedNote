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

struct PDFTasksPageContent {
    let tasks: [TaskModel]
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

    static func taskChunks(
        from tasks: [TaskModel],
        tasksPerPage: Int = 8
    ) -> [PDFTasksPageContent] {

        guard !tasks.isEmpty else {
            return []
        }

        return stride(
            from: 0,
            to: tasks.count,
            by: tasksPerPage
        ).map { startIndex in

            let endIndex = min(
                startIndex + tasksPerPage,
                tasks.count
            )

            return PDFTasksPageContent(
                tasks: Array(tasks[startIndex..<endIndex])
            )
        }
    }
}
