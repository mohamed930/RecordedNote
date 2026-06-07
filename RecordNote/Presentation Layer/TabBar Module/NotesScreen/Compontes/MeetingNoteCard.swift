//
//  MeetingNoteCard.swift
//  RecordNote
//
//  Created by Mohamed Ali on 07/06/2026.
//


import SwiftUI

struct MeetingNoteCardComponets: View {
    
    let attributes: MeetingNoteCardAttributes
    
    var onFavoriteTapped: (() -> Void)?
    var onTapped: (() -> Void)?
    
    var body: some View {
        Button {
            onTapped?()
        } label: {
            HStack(spacing: 16) {
                
                RoundedRectangle(cornerRadius: 3)
                    .fill(attributes.indicatorColor)
                    .frame(width: 6, height: 46)
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text(attributes.title)
                        .setFont(fontName: .mainFontBold, size: 16)
                        .lineLimit(1)
                    
                    HStack(spacing: 6) {
                        Text(attributes.date)
                        Text("·")
                        Text(attributes.time)
                    }
                    .setFont(fontName: .mainFont, size: 13)
                    .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Button {
                    onFavoriteTapped?()
                } label: {
                    Image(
                        systemName: attributes.isFavorite
                        ? "star.fill"
                        : "star"
                    )
                    .foregroundStyle(
                        attributes.isFavorite
                        ? .yellow
                        : .gray.opacity(0.5)
                    )
                }
                .buttonStyle(.plain)
                
                if attributes.showsChevron {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.gray.opacity(0.5))
                }
            }
            .padding(20)
            .background {
                RoundedRectangle(cornerRadius: 24)
                    .fill(.background)
                    .shadow(
                        color: .black.opacity(0.08),
                        radius: 8,
                        x: 0,
                        y: 2
                    )
            }
        }
        .buttonStyle(.plain)
    }
}
#Preview {
    MeetingNoteCardComponets(
        attributes: .init(
            id: "1",
            title: "Project Meeting Notes",
            date: "May 21, 2024",
            time: "05:30",
            indicatorColor: .purple
        )
    )
}
