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

extension NoteRealModelInfoModel {

    var shareText: String {
        var sections: [String] = []

        sections.append("📝 \(name)")
        sections.append("Date: \(formattedDate) • \(formattedTime)")

        if !summary.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            sections.append("""
            📄 Summary
            \(summary)
            """)
        }

        if !tasks.isEmpty {
            let taskText = tasks.map {
                "\($0.isDone ? "✅" : "⬜️") \($0.title)"
            }
            .joined(separator: "\n")

            sections.append("""
            ✅ Tasks
            \(taskText)
            """)
        }

        if !transcript.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            sections.append("""
            🗣 Transcript
            \(transcript)
            """)
        }

        return sections.joined(separator: "\n\n")
    }
}

extension NoteRealModelInfoModel {

    func toDTO() -> NoteDTO {
        NoteDTO(
            id: id,
            name: name,
            date: date,
            summary: summary,
            transcript: transcript,
            isFav: isFav,
            audio: audio,
            tasks: tasks.map { $0.toDTO() }
        )
    }
}

extension TaskModel {

    func toDTO() -> TaskDTO {
        TaskDTO(
            title: title,
            isDone: isDone
        )
    }
}


// MARK: - For PDF Stress Test
extension NoteRealModelInfoModel {

    static var pcintMock: NoteRealModelInfoModel {
        let note = NoteRealModelInfoModel()

        note.name = "Q3 Product Strategy & Engineering Planning Meeting"

        note.summary = """
        The team reviewed the roadmap for the upcoming quarter and discussed priorities across engineering, product, and design.

        Key decisions included moving the analytics dashboard to phase one, postponing the reporting module, and allocating additional resources to performance optimization.

        The discussion also covered customer feedback collected during the previous release cycle. Several recurring issues were identified, including slow loading times, inconsistent search behavior, and onboarding friction.

        Stakeholders agreed to focus on stability and user experience improvements before introducing new major features.

        The meeting concluded with action items assigned to engineering, product management, QA, and design teams.
        """

        note.transcript = """
        Product Manager: Welcome everyone. Today we will review the roadmap and align priorities for the next quarter.

        Engineering Lead: The main focus should be performance optimization. We've received multiple reports regarding slow application startup times and delays during note synchronization.

        QA Lead: We also identified several edge cases affecting search accuracy. The issue appears more frequently when users have a large number of stored notes.

        Product Manager: What is the estimated effort to address these concerns?

        Engineering Lead: Approximately three sprints. The first sprint will focus on profiling and identifying bottlenecks. The second sprint will cover implementation work, while the third sprint will focus on validation and regression testing.

        Design Lead: We should also revisit onboarding. New users are struggling to understand the transcript generation workflow.

        Product Manager: Agreed. Let's schedule a dedicated workshop for onboarding improvements.

        Engineering Lead: Another topic is PDF export. We need better support for large transcripts and multi-page rendering.

        QA Lead: Current exports work well for short notes, but we should test extremely large content before release.

        Product Manager: Let's create stress test scenarios.

        Engineering Lead: We should also validate behavior on different device sizes and operating system versions.

        QA Lead: I'll prepare a dedicated test plan.

        Product Manager: Great. Let's summarize the action items.

        ---
        This paragraph is intentionally repeated multiple times to simulate a very large transcript.

        This paragraph is intentionally repeated multiple times to simulate a very large transcript.

        This paragraph is intentionally repeated multiple times to simulate a very large transcript.

        This paragraph is intentionally repeated multiple times to simulate a very large transcript.

        This paragraph is intentionally repeated multiple times to simulate a very large transcript.

        This paragraph is intentionally repeated multiple times to simulate a very large transcript.

        This paragraph is intentionally repeated multiple times to simulate a very large transcript.

        This paragraph is intentionally repeated multiple times to simulate a very large transcript.

        This paragraph is intentionally repeated multiple times to simulate a very large transcript.

        This paragraph is intentionally repeated multiple times to simulate a very large transcript.

        End of transcript.
        """

        note.isFav = true

        note.tasks.append(
            objectsIn: [
                TaskModel(title: "Finalize Q3 roadmap", isDone: true),
                TaskModel(title: "Estimate engineering effort", isDone: true),
                TaskModel(title: "Prepare onboarding workshop", isDone: false),
                TaskModel(title: "Create PDF export stress tests", isDone: false),
                TaskModel(title: "Review search performance", isDone: false),
                TaskModel(title: "Analyze crash reports", isDone: true),
                TaskModel(title: "Improve analytics dashboard", isDone: false),
                TaskModel(title: "Validate large transcript rendering", isDone: false),
                TaskModel(title: "Prepare QA regression suite", isDone: false),
                TaskModel(title: "Release planning review", isDone: false)
            ]
        )

        return note
    }
}
