//
//  NoteRealModelInfoModel.swift
//  RecordNote
//
//  Created by Mohamed Ali on 06/06/2026.
//

import SwiftUI
import RealmSwift

class NoteRealModelInfoModel: Object {
    
    @Persisted(primaryKey: true)
    var id: String = UUID().uuidString

    @Persisted
    var name: String = ""
    
    @Persisted
    var date: Date = Date()

    @Persisted
    var summary: String = ""

    @Persisted
    var transcript: String = ""

    @Persisted
    var audio: Data?

    @Persisted
    var tasks = List<TaskModel>()
    
    func convertToDTO() -> MeetingNote {
        return MeetingNote(id: self.id,
                           title: self.name,
                           date: self.date,
                           indicatorColor: randomColor())
    }
    
    private let allColors: [Color] = [
        .red,
        .blue,
        .green,
        .orange,
        .purple,
        .pink,
        .mint,
        .teal,
        .indigo,
        .cyan
    ]

    private var availableColors: [Color] = []

    private func randomColor() -> Color {
        if availableColors.isEmpty {
            availableColors = allColors.shuffled()
        }

        return availableColors.removeFirst()
    }
}


final class TaskModel: EmbeddedObject {

    @Persisted var title: String = ""
    @Persisted var isDone: Bool = false

    convenience init(title: String, isDone: Bool) {
        self.init()
        self.title = title
        self.isDone = isDone
    }
}
