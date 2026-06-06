//
//  NoteCompents.swift
//  RecordNote
//
//  Created by Mohamed Ali on 06/06/2026.
//

import SwiftUI

import SwiftUI

struct MeetingNote: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
    let indicatorColor: Color
}

struct MeetingNoteCard: View {
    
    let note: MeetingNote
    
    private var formattedDate: String {
        note.date.formatted(.dateTime.month(.abbreviated).day().year())
    }
    
    private var formattedTime: String {
        note.date.formatted(date: .omitted, time: .shortened)
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            
            Circle()
                .fill(note.indicatorColor)
                .frame(width: 12, height: 12)
                .padding(.top, 4)
            
            VStack(alignment: .leading, spacing: 6) {
                
                Text(note.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                
                HStack(spacing: 8) {
                    Text(formattedDate)
                    Text("•")
                    Text(formattedTime)
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.background)
                .shadow(
                    color: .black.opacity(0.08),
                    radius: 8,
                    x: 0,
                    y: 4
                )
        )
    }
}

#Preview("Meeting Note Card") {
    MeetingNoteCard(
        note: .init(
            title: "Project Meeting Notes",
            date: Date(),
            indicatorColor: .purple
        )
    )
    .padding()
}
