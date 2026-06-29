//
//  NoteDetailsView.swift
//  RecordNote
//
//  Created Mohamed Ali on 11/06/2026.
//

import SwiftUI
import RealmSwift
import Combine

// MARK: - NoteDetailsView

struct NoteDetailsView: View {

    // MARK:- Private
    @ObservedObject private var viewModel: NoteDetailsViewModel
    @ObservedObject private var sheetManager: CustomSheetManager

    init(
        viewModel: NoteDetailsViewModel,
        sheetManager: CustomSheetManager
    ) {
        self.viewModel = viewModel
        self.sheetManager = sheetManager
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            
            Color.white
                .ignoresSafeArea()
            
            VStack(alignment: .leading,spacing: 0) {
                HStack(spacing: 12) {
                    Button {
                        viewModel.backToNotesScreen()
                    } label: {
                        Image(.backArrowBlack)
                    }
                    .frame(width: 32,height: 32)
                    
                    Text(viewModel.category)
                        .setFont(fontName: .mainFontMeduim, size: 12)
                        .foregroundStyle(Color._7_C_3_AED)
                        .padding()
                        .frame(height: 24)
                        .background(Color._7_C_3_AED.opacity(0.1))
                        .cornerRadius(12, corners: .allCorners)
                    
                    Spacer()
                    
                    Button {
                        viewModel.threeDotsButtonTapped()
                    } label: {
                        Image(viewModel.isMenuOpen ? .menuOpened : .threeDotsButton)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32)
                    }
                }
                .padding(.bottom,20)
                
                Text(viewModel.noteModel.name)
                    .setFont(fontName: .mainFontBold, size: 20)
                    .padding(.bottom,4)
                
                Text("\(viewModel.noteModel.formattedDate) . \(viewModel.noteModel.formattedTime)")
                    .setFont(fontName: .mainFont, size: 14)
                    .foregroundStyle(Color._99_A_1_AF)
                    .padding(.bottom,16)
                
                Divider()
                    .padding(.horizontal,-16)
                    .padding(.bottom,10)
                
                NotesSegmentView(selectedTab: $viewModel.selectedTab)
                    .padding(.bottom,22)
                
                switch viewModel.selectedTab {
                case .summary:
                    ReadOnlyTextView(text: viewModel.noteModel.summary,
                                     fontSize: 15,
                                     lineSpacing: 10)
                case .transcript:
                    ReadOnlyTextView(text: viewModel.noteModel.transcript,
                                     fontSize: 15,
                                     lineSpacing: 10)
                case .tasks:
                    VStack(spacing: 0) {
                        ForEach(Array(viewModel.tasksList.enumerated()), id: \.offset) { index, task in
                            TaskRow(
                                title: task.title,
                                isDone: task.isDone
                            ) {
                                viewModel.selectedNoteRowAction(index: index)
                            }

                            if index < viewModel.noteModel.tasks.count - 1 {
                                Divider()
                            }
                        }
                    }
                    .padding(.horizontal,16)
                }
                
                Spacer()
                
                AudioPlayerView(viewModel: viewModel.audioPlayerViewModel)
                .padding(.horizontal,-16)
            }
            .padding(.horizontal,16)
            
            if viewModel.isMenuOpen {
                MenuComponets { actions in
                    viewModel.menuActions(actionType: actions)
                }
                .padding(.top,40)
                .padding(.horizontal,18)
                .animation(
                    .spring(response: 0.25, dampingFraction: 1.0),
                    value: viewModel.isMenuOpen
                )
            }
            
            if viewModel.showAlert {
                AppAlert(isPresented: $viewModel.showAlert,
                         image: .attension,
                         title: "Delete Note",
                         message: "Are you sure to delete note?",
                         actionTitle: "Delete",
                         cancelTitle: "Cancel",
                         action:  {
                    viewModel.deleteOperation()
                })
            }
        }
        .appBottomSheet(manager: sheetManager, content: {
            PDFOptionsSheet(
                optionsSelected: viewModel.updatePDFOptions,
                buttonTapped: viewModel.generatePDF
            )
        })
        .sheet(item: $viewModel.shareItem, content: { item in
            if #available(iOS 16.0, *) {
                ShareSheet(item: item)
                    .presentationDetents([.medium])
            } else {
                // Fallback on earlier versions
                ShareSheet(item: item)
            }
        })
        .onTapGesture {
            if viewModel.isMenuOpen {
                viewModel.isMenuOpen = false
            }
        }
    }
}

#Preview {
    NoteDetailsView(
        viewModel: NoteDetailsViewModel(
            coordinator: NoteDetailsCoordinator(
                navigationController: UINavigationController(),
                note: .mock
            ),
            noteModel: .mock,
            useCases: NoteDetailsUseCases(
                respotery: NotesRespotery(realm: RealmStorage()), service: PDFExportService()
            ),
            sheetManager: CustomSheetManager()
        ),
        sheetManager: CustomSheetManager()
    )
}
