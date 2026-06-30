//
//  NotesSegmentView.swift
//  RecordNote
//
//  Created by Mohamed Ali on 11/06/2026.
//

import SwiftUI

struct NotesSegmentView: View {
    
    @Binding var selectedTab: NoteTab
    var isTappedImageVisisble: Bool
    
    init(selectedTab: Binding<NoteTab>,isTappedImageVisisble: Bool = false) {
        self._selectedTab = selectedTab
        self.isTappedImageVisisble = isTappedImageVisisble
    }

    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack {
                ForEach(NoteTab.allCases, id: \.self) { tab in
                    Button {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            selectedTab = tab
                        }
                    } label: {
                        VStack(spacing: 12) {
                            HStack(spacing: 6) {
                                
                                if isTappedImageVisisble {
                                    switch tab {
                                    case .summary:
                                        Image(systemName: "list.bullet")
                                    case .transcript:
                                        Image(systemName: "doc.text")
                                    case .tasks:
                                        Image(systemName: "checkmark.square")
                                    }
                                }
                                
                                Text(tab.rawValue)
                                    
                            }
                            .setFont(fontName: .mainFontSemiBold, size: 14)
                            .foregroundStyle(
                                selectedTab == tab
                                ? Color._7_C_3_AED
                                : Color._99_A_1_AF
                            )
                            
                            Rectangle()
                                .fill(
                                    selectedTab == tab
                                    ? Color._7_C_3_AED
                                    : Color.clear
                                )
                                .frame(height: 2)
                        }
                    }
                    .buttonStyle(.plain)
                    .frame(maxWidth: 100)
                }
                
                Spacer()
            }
            .padding(.top, 12)
            
            Divider()
        }
    }
}

#Preview {
    NotesSegmentView(selectedTab: .constant(.summary))
}
