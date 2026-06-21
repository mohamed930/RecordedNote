//
//  PDFExportServiceProtocol.swift
//  RecordNote
//
//  Created by Mohamed Ali on 20/06/2026.
//


import Foundation

protocol PDFExportServiceProtocol {
    func export(note: NoteRealModelInfoModel,duration: String ,options: [PDFContentOption]) async throws -> URL?
}
