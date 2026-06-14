//
//  MeetingNote.swift
//  RecordNote
//
//  Created by Mohamed Ali on 06/06/2026.
//

import Foundation
import SwiftUI

struct MeetingNote: Identifiable {
    let id: String
    let title: String
    let date: Date
    let indicatorColor: Color
}

extension Array where Element == MeetingNote {

    static let data: [MeetingNote] = [
        MeetingNote(
            id: UUID().uuidString,
            title: "AI Integration",
            date: .now,
            indicatorColor: .purple
        ),
        MeetingNote(
            id: UUID().uuidString,
            title: "iOS Architecture Review",
            date: .now.addingTimeInterval(-86_400),
            indicatorColor: .red
        ),
        MeetingNote(
            id: UUID().uuidString,
            title: "Sprint Planning Meeting",
            date: .now.addingTimeInterval(-172_800),
            indicatorColor: .blue
        )
    ]
}
