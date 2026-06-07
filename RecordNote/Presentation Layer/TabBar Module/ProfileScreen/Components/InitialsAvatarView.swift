//
//  InitialsAvatarView.swift
//  RecordNote
//
//  Created by Mohamed Ali on 07/06/2026.
//


import SwiftUI

struct InitialsAvatarView: View {
    
    let fullName: String
    var size: CGFloat = 120
    
    private var initials: String {
        let parts = fullName
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: " ")
        
        guard !parts.isEmpty else { return "" }
        
        let first = parts.first?.first.map(String.init) ?? ""
        let last = parts.count > 1
            ? parts.last?.first.map(String.init) ?? ""
            : ""
        
        return (first + last).uppercased()
    }
    
    var body: some View {
        Circle()
            .fill(
                LinearGradient(
                    colors: [
                        Color._7_C_3_AED,
                        Color.A_78_BFA
                    ],
                    startPoint: .topTrailing,
                    endPoint: .bottomLeading
                )
            )
            .overlay {
                Text(initials)
                    .font(.system(size: size * 0.28, weight: .bold))
                    .foregroundStyle(.white)
            }
            .frame(width: size, height: size)
            .shadow(color: .black.opacity(0.15),
                    radius: 12,
                    x: 0,
                    y: 6)
    }
}
#Preview {
    VStack(spacing: 24) {
        InitialsAvatarView(fullName: "Alex Johnson")
        InitialsAvatarView(fullName: "Mohamed Ali", size: 80)
        InitialsAvatarView(fullName: "Alex", size: 60)
    }
    .padding()
}
