//
//  String.swift
//  Morizone
//
//  Created by Mohamed Ali on 09/01/2026.
//

import Foundation
import SwiftUI

extension String {
    func toISODate() -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.date(from: self)
    }
    
    var localized: String {
        String(localized: String.LocalizationValue(self))
    }
}

extension Date {
    func timeAgo() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full   // short / abbreviated
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
