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

        let content = NotePDFView(
            noteModel: note,
            duration: duration,
            exportedOptions: options
        )
        .frame(width: a4Size.width)
        .background(Color.white)

        let renderer = ImageRenderer(content: content)

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

        pdf.beginPDFPage(nil)

        renderer.render { _, context in
            context(pdf)
        }

        pdf.endPDFPage()
        pdf.closePDF()

        return url
    }


}
