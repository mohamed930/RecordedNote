//
//  RoundedCorner.swift
//  CaptainWee
//
//  Created by Mohamed Ali on 26/06/2024.
//

import SwiftUI

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( 
            RoundedCorner(radius: radius, corners: corners)
        )
    }
    
    func borderedCornerRadius(_ radius: CGFloat, corners: UIRectCorner, lineWidth: CGFloat, borderColor: Color) -> some View {
        overlay(
            RoundedCorner(radius: radius, corners: corners)
                .stroke(borderColor, lineWidth: lineWidth)
        )
        .cornerRadius(radius, corners: corners)
    }
}


struct RoundedCorner1: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
