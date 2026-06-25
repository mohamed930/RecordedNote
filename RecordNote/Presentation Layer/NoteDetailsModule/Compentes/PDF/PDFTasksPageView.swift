//
//  PDFTasksPageView.swift
//  RecordNote
//
//  Created by Codex on 25/06/2026.
//

import SwiftUI

struct PDFTasksPageView: View {

    let exportDate: String
    let noteDate: String
    let tasks: [TaskModel]
    let currentPage: Int
    let totalPages: Int

    var body: some View {

        VStack(alignment: .leading, spacing: 20) {

            tasksHeader

            VStack(alignment: .leading, spacing: 0) {
                ForEach(tasks, id: \.title) { task in
                    HStack(alignment: .top) {
                        TaskRow(
                            title: task.title,
                            isDone: task.isDone
                        ) {}
                        .padding(.bottom, -5)

                        Spacer()

                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                            Text(noteDate)
                        }
                        .setFont(fontName: .mainFont, size: 12)
                        .foregroundStyle(Color._4_A_5565)
                        .padding(.top, 18)
                    }

                    Divider()
                        .padding(.bottom, -6)
                }
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

private extension PDFTasksPageView {

    var tasksHeader: some View {

        VStack(alignment: .leading, spacing: 12) {

            HStack {
                Image(.recordAppNote)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)

                Text("RecordNote")
                    .font(.headline)
                    .fontWeight(.semibold)

                Spacer()

                Text(exportDate)
                    .font(.caption)
            }

            Divider()

            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 12) {
                    Circle()
                        .fill(.A_78_BFA)
                        .overlay {
                            Image(systemName: "checklist")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        .frame(width: 40, height: 40)

                    Text("Tasks")
                        .setFont(fontName: .mainFontBold, size: 18)
                        .foregroundStyle(.A_78_BFA)
                }

                Divider()
                    .frame(height: 1.5)
                    .overlay(.A_78_BFA)
            }
        }
    }
}

#Preview {

    let taskPages = PDFPageBuilder.taskChunks(
        from: Array(NoteRealModelInfoModel.pcintMock.tasks)
    )

    PDFTasksPageView(
        exportDate: "Today",
        noteDate: NoteRealModelInfoModel.pcintMock.formattedDate,
        tasks: taskPages[0].tasks,
        currentPage: 2,
        totalPages: 3
    )
    .scaleEffect(0.5)
}
