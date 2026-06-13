//
//  AudioPlayerStateValues.swift
//  RecordNote
//
//  Created by Mohamed Ali on 13/06/2026.
//

import Foundation

enum AudioPlayerStateValues {
    case idle
    case loading
    case playing
    case paused
    case finished
    case failed(Error)
}

struct AudioItem {
    let id: String
    let url: URL
    let title: String?
}
