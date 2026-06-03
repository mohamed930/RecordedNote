//
//  HeaderComponets.swift
//  RecordNote
//
//  Created by Mohamed Ali on 27/05/2026.
//

import SwiftUI

struct HeaderComponets: View {
    
    var text: String
    var icon: ImageResource = .hi
    var isBackVisible: Bool
    var actionTapped: (() -> ())?
    
    var body: some View {
        ZStack {
            Color.EDE_9_FE
            
            VStack(spacing: 20) {
                HStack(spacing: 3) {
                    
                    Button {
                        actionTapped?()
                    } label: {
                        Image(.backButton)
                    }
                    .visibility(isBackVisible ? .visible :.invisible)

                    
                    Spacer()
                    
                    Text(text)
                        .setFont(fontName: .mainFont, size: 14)
                        .foregroundStyle(Color._7_C_3_AED)
                    
                    Image(icon)
                        .resizable()
                        .frame(width: 13,height: 13)
                }
                .padding(.top,30)
                
                Image(.record)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 130)
                
            }
            .padding(.horizontal,24)
        }
        .frame(maxHeight: 210)
    }
}

#Preview {
    HeaderComponets(text: "Welcome!",icon: .celebration, isBackVisible: true)
}
