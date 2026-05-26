//
//  SocialButton.swift
//  RecordNote
//
//  Created by Mohamed Ali on 26/05/2026.
//


import SwiftUI

struct SocialButton: View {

    let title: String
    let image: ImageResource

    var backgroundColor: Color = .white
    var borderColor: Color = .F_3_F_4_F_6.opacity(0.8)

    var action: (() -> Void)?

    var body: some View {

        Button {
            action?()
        } label: {

            HStack(spacing: 12) {

                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)

                Text(title)
                    .setFont(fontName: .mainFontMeduim, size: 13)
            }
            .foregroundColor(.black.opacity(0.75))
            .frame(maxWidth: .infinity)
            .frame(height: 51)
            .background(backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(borderColor, lineWidth: 1.5)
            )
            .clipShape(
                RoundedRectangle(cornerRadius: 20)
            )
            .shadow(
                color: .black.opacity(0.04),
                radius: 6,
                x: 0,
                y: 2
            )
        }
    }
}
#Preview {

    HStack(spacing: 20) {
        
        SocialButton(
            title: "Google",
            image: .google
        ) {
            print("Google tapped")
        }
        
        SocialButton(
            title: "Apple",
            image: .apple
        )
    }
    .padding()
}
