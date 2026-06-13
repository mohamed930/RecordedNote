//
//  TimeFormatter.swift
//  RecordNote
//
//  Created by Mohamed Ali on 13/06/2026.
//

import Foundation

extension Double {
    
    func formatTimer() -> String {
        let minutes = Int(self) / 60
        let seconds = Int(self) % 60

        return String(format: "%02d:%02d",
                      minutes,
                      seconds)
    }
    
}
