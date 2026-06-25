//
//  PDFExportService.swift
//  RecordNote
//
//  Created by Mohamed Ali on 20/06/2026.
//

import SwiftUI

final class PDFExportService: PDFExportServiceProtocol {
    
    private let a4Size = CGSize(
        width: 595.2,
        height: 841.8
    )
    
    @MainActor
    func export(
        note: NoteRealModelInfoModel,
        duration: String,
        options: [PDFContentOption]
    ) async throws -> URL? {

        guard #available(iOS 16.0, *) else {
            return nil
        }

        let taskPages = options.contains(.tasks)
            ? PDFPageBuilder.taskChunks(
                from: Array(note.tasks)
            )
            : []

        let transcriptPages = options.contains(.transcript)
            ? PDFPageBuilder.transcriptChunks(
                from: note.transcript
            )
            : []

        let totalPages = 1 + taskPages.count + transcriptPages.count
        var pages: [AnyView] = []
        let exportDate = Date.now.formatted()

        pages.append(
            AnyView(
                PDFFirstPageView(
                    note: note,
                    pdfOptions: options,
                    duration: duration,
                    currentPage: 1,
                    totalPages: totalPages
                )
            )
        )

        for taskPage in taskPages {
            pages.append(
                AnyView(
                    PDFTasksPageView(
                        exportDate: exportDate,
                        noteDate: note.formattedDate,
                        tasks: taskPage.tasks,
                        currentPage: pages.count + 1,
                        totalPages: totalPages
                    )
                )
            )
        }

        for page in transcriptPages {

            pages.append(
                AnyView(
                    PDFTranscriptPageView(
                        headerTitle: "Transcript",
                        exportDate: exportDate,
                        paragraphs: page.transcriptParagraphs,
                        currentPage: pages.count + 1,
                        totalPages: totalPages
                    )
                )
            )
        }

        print("Total PDF Pages: \(pages.count)")

        let url = FileManager.default
            .temporaryDirectory
            .appendingPathComponent("\(note.name)-\(Date()).pdf")

        var mediaBox = CGRect(
            origin: .zero,
            size: a4Size
        )

        guard let pdf = CGContext(
            url as CFURL,
            mediaBox: &mediaBox,
            nil
        ) else {
            return nil
        }

        for page in pages {

            let renderer = ImageRenderer(
                content: page
            )

            renderer.scale = 1

            pdf.beginPDFPage(nil)

            renderer.render { _, renderContext in
                renderContext(pdf)
            }

            pdf.endPDFPage()
        }

        pdf.closePDF()

        return url
    }
}

extension PDFExportService {
    
    private func makeContent(
        note: NoteRealModelInfoModel,
        duration: String,
        options: [PDFContentOption]
    ) -> some View {
        NotePDFView(
            noteModel: note,
            duration: duration,
            exportedOptions: options
        )
        .frame(width: a4Size.width)
        .background(.white)
    }
}
