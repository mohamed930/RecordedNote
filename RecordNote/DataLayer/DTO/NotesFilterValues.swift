//
//  NotesFilterValues.swift
//  RecordNote
//
//  Created by Mohamed Ali on 07/06/2026.
//

import Foundation

enum NotesFilterValues: String, CaseIterable, Identifiable {
    case all = "All"
    case favorites = "Favorites"
    case meetings = "Meetings"
    case ideas = "Ideas"

    var id: String { rawValue }
}
