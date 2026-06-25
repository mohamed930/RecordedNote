//
//  PDFFirstPageView.swift
//  RecordNote
//
//  Created by Mohamed Ali on 23/06/2026.
//

import SwiftUI

struct PDFFirstPageView: View {

    let note: NoteRealModelInfoModel
    let pdfOptions: [PDFContentOption]
    let duration: String
    let currentPage: Int
    let totalPages: Int

    var body: some View {

        VStack(alignment: .leading, spacing: 24) {

            headerSection

            VStack(alignment: .leading,spacing: 12) {
                Text(note.name)
                    .setFont(fontName: .mainFontBold, size: 26)
                    .fixedSize(
                            horizontal: false,
                            vertical: true
                        )
                    .lineLimit(2)

                metadataRow(icon: "calendar", text: note.formattedDate)
                metadataRow(icon: "clock", text: "Duration: \(duration)")
            }

            if pdfOptions.contains(.summary) {
                
                sectionContainer(title: "Summary",
                                 icon: "doc.text",
                                 accentColor: .A_78_BFA) {
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text(note.summary)
                            .setFont(fontName: .mainFont, size: 15)
                            .foregroundStyle(Color._111827)
                    }
                }
            }

            if pdfOptions.contains(.tasks) {
//                tasksSection
                
                sectionContainer(title: "Tasks",
                                 icon: "checklist",
                                 accentColor: .A_78_BFA) {
                    
                    VStack(alignment: .leading,spacing: 0) {
                        ForEach(note.tasks, id: \.title) { task in
                            HStack(alignment: .top) {
                                TaskRow(
                                    title: task.title,
                                    isDone: task.isDone
                                ) {}
                                    .padding(.bottom,-5)
                                
                                Spacer()
                                
                                HStack(spacing: 4) {
                                    Image(systemName: "calendar")
                                    Text(note.formattedDate)
                                }
                                .setFont(fontName: .mainFont, size: 12)
                                .foregroundStyle(Color._4_A_5565)
                                .padding(.top, 18)
                            }
                            
                            Divider()
                                .padding(.bottom,-6)
                        }
                    }
                }
                .padding(.bottom)
            }

            Spacer()

            PDFFooterView(currentPage: currentPage,
                          totalPages: totalPages)
        }
        .padding(24)
        .frame(
            width: 595.2,
            height: 841.8,
            alignment: .topLeading
        )
        .background(.white)
    }
}

private extension PDFFirstPageView {
    
    var headerSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Image(.recordAppNote)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18)

                Text("RecordNote")
                    .setFont(fontName: .mainFontBold, size: 15)

                Spacer()

                Text("Exported on \(Date().stringDate(formate: "dd/MM/yyyy"))")
                    .setFont(fontName: .mainFontMeduim, size: 11)
                    .foregroundStyle(Color._6_A_7282)
            }
            .padding(.horizontal)

            Divider()
                .padding(.top, 16)
                .padding(.bottom, -10)
                .padding(.horizontal)
        }
    }
    
    func metadataRow(icon: String, text: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
            Text(text)
        }
        .setFont(fontName: .mainFont, size: 13)
        .foregroundStyle(Color._374151)
    }
    
    
    func sectionContainer<Content: View>(
        title: String,
        icon: String,
        accentColor: Color,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Circle()
                    .fill(accentColor)
                    .overlay {
                        Image(systemName: icon)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    .frame(width: 40, height: 40)

                Text(title)
                    .setFont(fontName: .mainFontBold, size: 18)
                    .foregroundStyle(accentColor)
            }

            Divider()
                .frame(height: 1.5)
                .overlay(accentColor)

            content()
        }
    }
}

#Preview {
    PDFFirstPageView(
        note: .pcintMock,
        pdfOptions: [.summary,.tasks,.transcript],
        duration: "29:10",
        currentPage: 1,
        totalPages: 2
    )
    
}
