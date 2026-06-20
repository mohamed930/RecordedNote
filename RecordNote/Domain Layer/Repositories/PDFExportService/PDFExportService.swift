//
//  PDFExportService.swift
//  RecordNote
//
//  Created by Mohamed Ali on 20/06/2026.
//

import SwiftUI

final class PDFExportService: PDFExportServiceProtocol {
    
    @MainActor
    func export(note: NoteRealModelInfoModel, options: [PDFContentOption]) async throws -> URL? {
        if #available(iOS 16.0, *) {
            let renderer = ImageRenderer(
                content: NotePDFView()
            )
            
            let url = FileManager.default
                    .temporaryDirectory
                    .appendingPathComponent("note.pdf")
            
            renderer.render { size, context in
                    
                var box = CGRect(
                    origin: .zero,
                    size: size
                )

                guard let pdf = CGContext(
                    url as CFURL,
                    mediaBox: &box,
                    nil
                ) else { return }

                pdf.beginPDFPage(nil)
                context(pdf)
                pdf.endPDFPage()
                pdf.closePDF()
            }

            return url
            
        } else {
            // Fallback on earlier versions
            return nil
        }
    }
    
    
}
