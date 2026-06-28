//
//  NoteDetailsUseCases.swift
//  RecordNote
//
//  Created by Mohamed Ali on 13/06/2026.
//

import Foundation

final class NoteDetailsUseCases {
    
    var respotery: NotesRespotery
    var service: PDFExportServiceProtocol
    
    init(respotery: NotesRespotery,service: PDFExportServiceProtocol) {
        self.respotery = respotery
        self.service = service
    }
    
    func updateTaskDetails(note: NoteRealModelInfoModel,index: Int,isDone: Bool) -> Bool {
        respotery.updateTask(note: note, index: index, isDone: isDone)
    }
    
    func execute(note: NoteRealModelInfoModel,duration: String,options: [PDFContentOption]) async throws -> URL? {
        try await service.export(
            note: note,
            duration: duration,
            options: options
        )
    }
    
    func deleteNote(note: NoteRealModelInfoModel) -> Bool {
        respotery.deleteNote(note: note)
    }
}
