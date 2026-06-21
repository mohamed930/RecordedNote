//
//  Date.swift
//  Masar
//
//  Created by Mohamed Ali on 16/10/2024.
//

import Foundation

extension Date {
    func stringDate(formate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formate
        return dateFormatter.string(from: self)
    }
    
    func formattedTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: self)
    }
}
