//
//  EditNoteViewModel.swift
//  RecordNote
//
//  Created by Mohamed Ali on 29/06/2026.
//

import Foundation
import Combine
import SwiftUI

enum EditNoteOverlayMode {
    case date
    case time
}

class EditNoteViewModel: ObservableObject {
    
    // MARK: - Publishers.
    @Published var note: NoteDTO
    private var noteModel: NoteRealModelInfoModel
    @Published var noteTitle: String = ""
    @Published var category: String = "Meeting"
    @Published var showCalendar: Bool = false
    @Published var overlayMode: EditNoteOverlayMode = .date
    @Published var selectedDate: Date = Date()
    @Published var draftSelectedDate: Date = Date()
    @Published var draftSelectedTime: Date = Date()
    @Published var selectedTab: NoteTab = .summary
    @Published var noteSummary: String = ""
    @Published var countString: String = ""
    @Published var noteTranscript: String = ""
    @Published var transScriptCount: String = ""
    
    // MARK: - Depandancy
    weak var coordinator: EditNoteCoordinator?
    @Published var calenderConfiguration: CalendarConfiguration
    
    init(coordinator: EditNoteCoordinator?,
         calenderConfiguration: CalendarConfiguration = CalendarConfiguration(selectionMode: .single),
         noteModel: NoteRealModelInfoModel) {
        self.coordinator = coordinator
        self.noteModel = noteModel
        self.note = noteModel.toDTO()
        
        self.calenderConfiguration = calenderConfiguration
        configureTheme()
        
        fetchData()
    }
    
    private func configureTheme() {
        self.calenderConfiguration.selectedDayColor = .A_78_BFA
        self.calenderConfiguration.todayBorderColor = .A_78_BFA
        self.calenderConfiguration.accentColor = .A_78_BFA
        self.calenderConfiguration.cornerRadius = 28
    }
    
    func fetchData() {
        noteTitle = note.name
        selectedDate = note.date
        draftSelectedDate = note.date
        draftSelectedTime = note.date
        calenderConfiguration.initialMonth = note.date
        noteSummary = note.summary
        countString = "\(noteSummary.count) / 2000"
        noteTranscript = note.transcript
        transScriptCount = "\(noteTranscript.count) / 20000"
    }
    
    // MARK: - Actions.
    func backToNoteDetailsScreen() {
        coordinator?.moveToNoteDetailsScreen()
    }
    
    func saveEditAndRefreshScreen() {
        coordinator?.moveToNoteDetailsScreen()
    }
    
    func clear() {
        noteTitle = ""
    }
    
    func updateDate() {
        overlayMode = .date
        draftSelectedDate = selectedDate
        showCalendar = true
    }

    func confirmDateSelection() {
        selectedDate = mergeDate(draftSelectedDate, withTimeFrom: selectedDate)
        note = updatedNote(date: selectedDate)
        showCalendar = false
    }

    func discardDateSelection() {
        draftSelectedDate = selectedDate
        draftSelectedTime = selectedDate
        showCalendar = false
    }
    
    func updateTime() {
        overlayMode = .time
        draftSelectedTime = selectedDate
        showCalendar = true
    }

    func confirmTimeSelection() {
        selectedDate = mergeTime(draftSelectedTime, withDateFrom: selectedDate)
        note = updatedNote(date: selectedDate)
        showCalendar = false
    }

    private func updatedNote(date: Date) -> NoteDTO {
        NoteDTO(
            id: note.id,
            name: note.name,
            date: date,
            summary: note.summary,
            transcript: note.transcript,
            isFav: note.isFav,
            audio: note.audio,
            tasks: note.tasks
        )
    }
}

extension EditNoteViewModel {
    private func mergeDate(_ newDate: Date, withTimeFrom sourceDate: Date) -> Date {
        let calendar = calenderConfiguration.calendar
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: sourceDate)
        let dayComponents = calendar.dateComponents([.year, .month, .day], from: newDate)

        var mergedComponents = DateComponents()
        mergedComponents.year = dayComponents.year
        mergedComponents.month = dayComponents.month
        mergedComponents.day = dayComponents.day
        mergedComponents.hour = timeComponents.hour
        mergedComponents.minute = timeComponents.minute
        mergedComponents.second = timeComponents.second

        return calendar.date(from: mergedComponents) ?? newDate
    }

    private func mergeTime(_ newTime: Date, withDateFrom sourceDate: Date) -> Date {
        let calendar = calenderConfiguration.calendar
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: newTime)
        let dayComponents = calendar.dateComponents([.year, .month, .day], from: sourceDate)

        var mergedComponents = DateComponents()
        mergedComponents.year = dayComponents.year
        mergedComponents.month = dayComponents.month
        mergedComponents.day = dayComponents.day
        mergedComponents.hour = timeComponents.hour
        mergedComponents.minute = timeComponents.minute
        mergedComponents.second = timeComponents.second

        return calendar.date(from: mergedComponents) ?? sourceDate
    }
}
