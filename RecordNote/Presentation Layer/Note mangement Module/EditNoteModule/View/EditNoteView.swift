//
//  EditNoteView.swift
//  RecordNote
//
//  Created by Mohamed Ali on 29/06/2026.
//

import SwiftUI

struct EditNoteView: View {
    
    @ObservedObject var viewModel: EditNoteViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: - Header view.
            HStack(spacing: 0) {
                
                Button {
                    viewModel.backToNoteDetailsScreen()
                } label: {
                    Image(systemName: "xmark")
                        .setFont(fontName: .mainFont, size: 20)
                        .foregroundStyle(Color._374151)
                }
                .frame(width: 36,height: 36)

                
                Spacer()
                
                Text("Edit Note")
                    .setFont(fontName: .mainFontBold, size: 22)
                
                Spacer()
                
                Button {
                    viewModel.saveEditAndRefreshScreen()
                } label: {
                    Text("Save")
                        .setFont(fontName: .mainFontBold, size: 20)
                        .foregroundStyle(Color.A_78_BFA)
                }
                .frame(height: 36)
            }
            .padding(.horizontal,20)
            .padding(.bottom,20)
            
            // MARK: - header that update the name and section.
            ZStack {
                VStack(alignment: .leading,spacing: 0) {
                    
                    Text("Title")
                        .setFont(fontName: .mainFont, size: 12)
                        .foregroundStyle(Color._99_A_1_AF)
                        .padding(.bottom,3)
                    
                    HStack {
                        TextField("Note title", text: $viewModel.noteTitle)
                            .setFont(fontName: .mainFontBold, size: 18)
                        
                        if !viewModel.noteTitle.isEmpty {
                            Button {
                                viewModel.clear()
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.gray)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.bottom,12)
                    
                    Divider()
                        .padding(.bottom,12)
                    
                    HStack(spacing: 14) {
                        
                        Button {
                            viewModel.updateDate()
                        } label: {
                            HStack {
                                Image(systemName: "calendar")
                                    .setFont(fontName: .mainFont, size: 14)
                                    .foregroundStyle(Color._99_A_1_AF)
                                
                                Text(viewModel.selectedDate.formatted(.dateTime.day().month(.abbreviated).year()))
                                    .setFont(fontName: .mainFont, size: 12)
                                    .foregroundStyle(Color._6_B_7280)
                            }
                        }
                        
                        Divider()
                        
                        Button {
                            viewModel.updateTime()
                        } label: {
                            HStack {
                                Image(systemName: "clock")
                                    .setFont(fontName: .mainFont, size: 14)
                                    .foregroundStyle(Color._99_A_1_AF)
                                
                                Text(viewModel.selectedDate.formatted(date: .omitted, time: .shortened))
                                    .setFont(fontName: .mainFont, size: 12)
                                    .foregroundStyle(Color._6_B_7280)
                            }
                        }

                    }
                    .frame(maxHeight: 20)
                    .padding(.bottom,12)
                    
                    Text(viewModel.category)
                        .setFont(fontName: .mainFontMeduim, size: 12)
                        .foregroundStyle(Color._7_C_3_AED)
                        .padding()
                        .frame(height: 24)
                        .background(Color._7_C_3_AED.opacity(0.1))
                        .cornerRadius(12, corners: .allCorners)
                        
                    
                    Spacer()
                    
                }
                .padding(16)
            }
            .frame(maxHeight: 151)
            .borderedCornerRadius(12, corners: .allCorners, lineWidth: 1, borderColor: .EBEBEF)
            .padding(.horizontal,20)
            
            Spacer()
        }
        .overlay {

            if viewModel.showCalendar {

                ZStack {
                    Color.black.opacity(0.45)
                        .ignoresSafeArea()
                        .onTapGesture {
                            viewModel.discardDateSelection()
                        }

                    switch viewModel.overlayMode {
                    case .date:
                        CalendarPickerView(
                            configuration: viewModel.calenderConfiguration,
                            selectedDate: $viewModel.draftSelectedDate,
                            onConfirm: viewModel.confirmDateSelection,
                            onCancel: viewModel.discardDateSelection
                        )
                        .frame(width: 340)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .shadow(radius: 20)

                    case .time:
                        TimePickerOverlayView(
                            configuration: viewModel.calenderConfiguration,
                            selectedTime: $viewModel.draftSelectedTime,
                            onConfirm: viewModel.confirmTimeSelection,
                            onCancel: viewModel.discardDateSelection
                        )
                        .frame(width: 340)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .shadow(radius: 20)
                    }
                }
            }
        }
    }
}

#Preview {
    EditNoteView(viewModel: EditNoteViewModel(coordinator: EditNoteCoordinator(navigationController: UINavigationController(), note: .mock), noteModel: .mock))
}
