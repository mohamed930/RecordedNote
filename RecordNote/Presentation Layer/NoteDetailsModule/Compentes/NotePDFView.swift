//
//  NotePDFView.swift
//  RecordNote
//
//  Created by Mohamed Ali on 20/06/2026.
//

import SwiftUI

struct NotePDFView: View {
    private enum Layout {
        static let pageMinHeight: CGFloat = 841.8
        static let horizontalPadding: CGFloat = 28
        static let headerHorizontalPadding: CGFloat = 24
    }

    var noteModel: NoteRealModelInfoModel
    var duration: String
    var exportedOptions: [PDFContentOption]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerSection

            VStack(alignment: .leading, spacing: 24) {
                contentSection

                if shouldShowTranscript {
                    transcriptSection
                }
            }
            .padding(.horizontal, Layout.horizontalPadding)

//            Spacer(minLength: 40)

            footerSection
        }
        .frame(
            maxWidth: .infinity,
            alignment: .topLeading
        )
        .padding(.top, 24)
        .background(Color.white)
    }
}

private extension NotePDFView {
    var headerSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Image(.recordAppNote)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 34)

                Text("RecordNote")
                    .setFont(fontName: .mainFontBold, size: 15)

                Spacer()

                Text("Exported on \(Date().stringDate(formate: "dd/MM/yyyy"))")
                    .setFont(fontName: .mainFontMeduim, size: 11)
                    .foregroundStyle(Color._6_A_7282)
            }
            .padding(.horizontal, Layout.headerHorizontalPadding)

            Divider()
                .padding(.top, 16)
                .padding(.bottom, 28)

            VStack(alignment: .leading, spacing: 10) {
                Text(noteModel.name)
                    .setFont(fontName: .mainFontBold, size: 24)
                    .padding(.bottom, 4)

                metadataRow(icon: "calendar", text: noteModel.formattedDate)
                metadataRow(icon: "clock", text: "Duration: \(duration)")
            }
            .padding(.horizontal, Layout.horizontalPadding)
            .padding(.bottom, 24)
        }
    }

    @ViewBuilder
    var contentSection: some View {
        let hasContent = shouldShowSummary || shouldShowTasks

        if hasContent {
            sectionContainer(
                title: "Content",
                icon: "doc.text",
                accentColor: Color.A_78_BFA
            ) {
                VStack(alignment: .leading, spacing: 20) {
                    if shouldShowSummary {
                        textBlockSection(title: "Summary", text: noteModel.summary)
                    }

                    if shouldShowTasks {
                        tasksBlock
                    }
                }
            }
        }
    }

    var transcriptSection: some View {
        sectionContainer(
            title: "Transcript",
            icon: "mic",
            accentColor: Color.A_78_BFA
        ) {
            Text(noteModel.transcript)
                .setFont(fontName: .mainFont, size: 15)
                .foregroundStyle(Color._111827)
        }
    }

    var tasksBlock: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Tasks")
                .setFont(fontName: .mainFontSemiBold, size: 16)
                .foregroundStyle(Color._111827)

            ForEach(noteModel.tasks, id: \.title) { task in
                HStack(alignment: .top, spacing: 12) {
                    TaskRow(
                        title: task.title,
                        isDone: task.isDone
                    ) {}

                    Spacer(minLength: 12)

                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                        Text(noteModel.formattedDate)
                    }
                    .setFont(fontName: .mainFont, size: 12)
                    .foregroundStyle(Color._4_A_5565)
                    .padding(.top, 18)
                }
            }
        }
    }

    var footerSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Divider()
                .padding(.bottom, 12)

            HStack {
                Text("This document was generated using RecordNote.")

                Spacer()

                Text("Page 1 of 2")
            }
            .setFont(fontName: .mainFont, size: 12)
            .foregroundStyle(Color._6_A_7282)
            .padding(.horizontal, 16)
            .padding(.bottom, 10)
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

    func textBlockSection(title: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .setFont(fontName: .mainFontSemiBold, size: 16)
                .foregroundStyle(Color._111827)

            Text(text)
                .setFont(fontName: .mainFont, size: 15)
                .foregroundStyle(Color._111827)
        }
    }

    var shouldShowSummary: Bool {
        exportedOptions.contains(.summary)
    }

    var shouldShowTasks: Bool {
        exportedOptions.contains(.tasks)
    }

    var shouldShowTranscript: Bool {
        exportedOptions.contains(.transcript)
    }
}

#Preview {
    NotePDFView(
        noteModel: .mock,
        duration: "10:00",
        exportedOptions: [.summary, .tasks, .transcript]
    )
}
