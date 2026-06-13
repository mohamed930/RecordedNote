//
//  NoteDetailsUseCases.swift
//  RecordNote
//
//  Created by Mohamed Ali on 13/06/2026.
//

import Foundation

final class NoteDetailsUseCases {
    
    var respotery: NotesRespotery
    
    init(respotery: NotesRespotery) {
        self.respotery = respotery
    }
    
    func updateTaskDetails(note: NoteRealModelInfoModel,index: Int,isDone: Bool) -> Bool {
        respotery.updateTask(note: note, index: index, isDone: isDone)
    }
}
