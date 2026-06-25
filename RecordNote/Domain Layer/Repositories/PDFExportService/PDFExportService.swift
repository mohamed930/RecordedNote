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
    
    //    @MainActor
    //    func export(
    //    note: NoteRealModelInfoModel,
    //    duration: String,
    //    options: [PDFContentOption]
    //    ) async throws -> URL? {
    //        guard #available(iOS 16.0, *) else {
    //            return nil
    //        }
    //
    //        let chunks = PDFPageBuilder
    //            .transcriptChunks(
    //                from: note.transcript
    //            )
    //
    //        print("Chunks Count:", chunks.count)
    //
    //        for (index, chunk) in chunks.enumerated() {
    //            print(
    //                "Chunk \(index + 1):",
    //                chunk.transcriptParagraphs.count
    //            )
    //        }
    //
    //        return nil
    //
    ////        let content = makeContent(note: note,
    ////                                  duration: duration,
    ////                                  options: options)
    ////
    ////        let hostingController = UIHostingController(
    ////            rootView: content
    ////        )
    ////
    ////        let size = hostingController.sizeThatFits(
    ////            in: CGSize(
    ////                width: a4Size.width,
    ////                height: .greatestFiniteMagnitude
    ////            )
    ////        )
    ////
    ////        print("size Heigh: \(size.height)")
    ////
    ////        let contentHeight = size.height
    ////        let safePageHeight = a4Size.height - 60
    ////
    ////        let pageCount = Int(
    ////            ceil(contentHeight / safePageHeight)
    ////        )
    ////
    ////        print("Content Height:", contentHeight)
    ////        print("Pages:", pageCount)
    ////
    ////        let renderer = ImageRenderer(content: content)
    ////        renderer.scale = 1
    ////
    ////        let url = FileManager.default
    ////            .temporaryDirectory
    ////            .appendingPathComponent("note.pdf")
    ////
    ////        var mediaBox = CGRect(
    ////            origin: .zero,
    ////            size: a4Size
    ////        )
    ////
    ////        guard let pdf = CGContext(
    ////            url as CFURL,
    ////            mediaBox: &mediaBox,
    ////            nil
    ////        ) else {
    ////            return nil
    ////        }
    ////
    ////
    ////        for pageIndex in 0..<pageCount {
    ////
    ////            let pageTopInset: CGFloat = 50
    ////            let offsetY = CGFloat(pageIndex) * safePageHeight
    ////
    ////            pdf.beginPDFPage(nil)
    ////
    ////            renderer.render { _, renderContext in
    ////
    ////                pdf.saveGState()
    ////
    ////                pdf.clip(to: CGRect(
    ////                    x: 0,
    ////                    y: 0,
    ////                    width: a4Size.width,
    ////                    height: a4Size.height
    ////                ))
    ////
    ////                pdf.translateBy(
    ////                    x: 0,
    ////                    y: pageTopInset - offsetY
    ////                )
    ////
    ////                renderContext(pdf)
    ////
    ////                pdf.restoreGState()
    ////            }
    ////
    ////            pdf.endPDFPage()
    ////        }
    ////
    ////        return url
    //    }
    
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
            .appendingPathComponent("note.pdf")

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
