//
//  MeetingNoteCardAttributes.swift
//  RecordNote
//
//  Created by Mohamed Ali on 07/06/2026.
//

import SwiftUI

struct MeetingNoteCardAttributes {
    let id: String
    let title: String
    let date: String
    let time: String
    let indicatorColor: Color
    
    var isFavorite: Bool = false
    var showsChevron: Bool = true
}

extension Array where Element == MeetingNoteCardAttributes {
    static let dummyNotes: [MeetingNoteCardAttributes] = [
        .init(
            id: "1",
            title: "Project Meeting Notes",
            date: "May 21, 2024",
            time: "05:30",
            indicatorColor: .purple
        ),
        
        .init(
            id: "2",
            title: "Ideas for Mobile App",
            date: "May 20, 2024",
            time: "03:15",
            indicatorColor: .orange
        ),
        
        .init(
            id: "3",
            title: "Daily Journal",
            date: "May 20, 2024",
            time: "02:45",
            indicatorColor: .green
        ),
        
        .init(
            id: "4",
            title: "Client Call - Acme Inc.",
            date: "May 19, 2024",
            time: "06:10",
            indicatorColor: .purple,
            isFavorite: true
        ),
        
        .init(
            id: "5",
            title: "Product Ideas Brainstorm",
            date: "May 18, 2024",
            time: "04:50",
            indicatorColor: .orange
        ),
        
//        .init(
//            id: "6",
//            title: "Product Ideas Brainstorm",
//            date: "May 18, 2024",
//            time: "04:50",
//            indicatorColor: .orange
//        ),
//        
//        .init(
//            id: "7",
//            title: "Product Ideas Brainstorm",
//            date: "May 18, 2024",
//            time: "04:50",
//            indicatorColor: .orange
//        ),
//    
//        .init(
//            id: "8",
//            title: "Product Ideas Brainstorm",
//            date: "May 18, 2024",
//            time: "04:50",
//            indicatorColor: .orange
//        )
    ]
}
