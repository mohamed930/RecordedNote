//
//  NoteDTO.swift
//  RecordNote
//
//  Created by Mohamed Ali on 28/06/2026.
//


import Foundation
import SwiftUI

struct NoteDTO: Identifiable, Hashable {
    let id: String
    let name: String
    let date: Date
    let summary: String
    let transcript: String
    let isFav: Bool
    let audio: String?
    let tasks: [TaskDTO]
    
    var formattedDate: String {
        self.date.formatted(.dateTime.month(.abbreviated).day().year())
    }
    
    var formattedTime: String {
        self.date.formatted(date: .omitted, time: .shortened)
    }
}

struct TaskDTO: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let isDone: Bool
}
