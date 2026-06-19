//
//  SettingsRow.swift
//  RecordNote
//
//  Created by Mohamed Ali on 07/06/2026.
//

import SwiftUI

struct SettingsRow: View {
    
    let title: String
    let icon: ImageResource
    
    var textColor: Color = .black
    var showsChevron: Bool = true
    var isCenter: Bool = true
    
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button {
            action?()
        } label: {
            HStack(spacing: 16) {
                
                Image(icon)
                
                Text(title)
                    .setFont(fontName: isCenter ? .mainFontMeduim : .mainFontSemiBold, size: 16)
                    .foregroundStyle(textColor)
                    .frame(maxWidth: .infinity, alignment: isCenter ? .center : .leading)
                
                if showsChevron {
                    Image(systemName: "chevron.right")
                        .font(.title3)
                        .foregroundStyle(.gray.opacity(0.5))
                }
            }
            .padding(.horizontal)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SettingsRow( title: "Settings", icon: .settings, showsChevron: false ,isCenter: false)
}
