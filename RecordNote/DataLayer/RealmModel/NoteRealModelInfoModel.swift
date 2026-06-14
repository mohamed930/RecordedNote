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
    var isFav: Bool = false

    @Persisted
    var audio: String?

    @Persisted
    var tasks = List<TaskModel>()
    
    func convertToDTO() -> MeetingNote {
        return MeetingNote(id: self.id,
                           title: self.name,
                           date: self.date,
                           indicatorColor: randomColor())
    }
    
    func convertToMeetingNoteCardAttributes() -> MeetingNoteCardAttributes {
        return MeetingNoteCardAttributes(id: self.id,
                                         title: self.name,
                                         date: formattedDate,
                                         time: formattedTime,
                                         indicatorColor: randomColor(),
                                         isFavorite: self.isFav)
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
    
    var formattedDate: String {
        self.date.formatted(.dateTime.month(.abbreviated).day().year())
    }
    
    var formattedTime: String {
        self.date.formatted(date: .omitted, time: .shortened)
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


// MARK: - For dummy test only.
extension NoteRealModelInfoModel {
    static var mock: NoteRealModelInfoModel {
        let note = NoteRealModelInfoModel()
        note.name = "Sprint Planning Meeting"
        note.summary = "Discussed sprint goals and backlog priorities."
        note.transcript = "Detailed meeting transcript goes here."
        note.isFav = true

        note.tasks.append(
            objectsIn: [
                TaskModel(title: "Finalize sprint backlog", isDone: true),
                TaskModel(title: "Assign stories", isDone: false)
            ]
        )

        return note
    }
}
