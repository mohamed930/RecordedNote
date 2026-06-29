//
//  CalenderConfiguration.swift
//  RecordNote
//
//  Created by Mohamed Ali on 29/06/2026.
//

import SwiftUI
import HorizonCalendar

enum CalendarSelectionMode {
    case single
    case multiple
    case range
}

final class CalendarConfiguration {

    // MARK: - Selection

    var selectionMode: CalendarSelectionMode = .single

    // MARK: - Calendar

    var calendar: Calendar = .current

    var visibleDateRange: ClosedRange<Date>

    var initialMonth: Date?

    var monthsLayout: MonthsLayout = .horizontal

    // MARK: - Validation

    var allowsPastDates: Bool = true

    var allowsFutureDates: Bool = true

    var minimumDate: Date?

    var maximumDate: Date?

    // MARK: - Appearance

    var accentColor: Color = .purple

    var backgroundColor: Color = .white

    var monthTitleColor: Color = .primary

    var weekdayColor: Color = .gray

    var dayTextColor: Color = .primary

    var selectedDayColor: Color = .purple

    var selectedTextColor: Color = .white

    var todayBorderColor: Color = .purple

    var disabledDayColor: Color = .gray.opacity(0.5)

    // MARK: - Layout

    var cornerRadius: CGFloat = 24

    var shadowRadius: CGFloat = 20

    var daySize: CGFloat = 42

    var contentInsets: EdgeInsets = EdgeInsets(
        top: 24,
        leading: 24,
        bottom: 24,
        trailing: 24
    )

    // MARK: - Buttons

    var showsSaveButton = true

    var showsCancelButton = true

    var showsClearButton = false

    var saveButtonTitle = "Confirm"

    var cancelButtonTitle = "Discard"

    var clearButtonTitle = "Clear"

    // MARK: - Init

    init(
        selectionMode: CalendarSelectionMode = .single,
        visibleDateRange: ClosedRange<Date> = {
            let calendar = Calendar.current
            let start = calendar.date(byAdding: .year, value: -10, to: Date())!
            let end = calendar.date(byAdding: .year, value: 10, to: Date())!
            return start...end
        }(),
        initialMonth: Date? = Date()
    ) {
        self.selectionMode = selectionMode
        self.visibleDateRange = visibleDateRange
        self.initialMonth = initialMonth
    }
}

struct CalendarPickerView: View {

    let configuration: CalendarConfiguration
    @Binding var selectedDate: Date
    let onConfirm: () -> Void
    let onCancel: () -> Void

    @StateObject private var calendarProxy = CalendarViewProxy()

    var body: some View {
        VStack(spacing: 20) {
            HorizonCalendar.CalendarViewRepresentable(
                calendar: configuration.calendar,
                visibleDateRange: configuration.visibleDateRange,
                monthsLayout: configuration.monthsLayout,
                dataDependency: selectedDate,
                proxy: calendarProxy
            )
            .interMonthSpacing(20)
            .verticalDayMargin(10)
            .horizontalDayMargin(10)
            .monthHeaderItemProvider { month in
                monthHeaderItem(for: month)
            }
            .dayOfWeekItemProvider { _, weekdayIndex in
                dayOfWeekItem(for: weekdayIndex)
            }
            .dayItemProvider { day in
                dayItem(for: day)
            }
            .onDaySelection { day in
                guard let date = configuration.calendar.date(from: day.components),
                      isDateEnabled(date) else { return }
                selectedDate = date
            }
            .frame(height: 320)

            HStack(spacing: 12) {
                if configuration.showsCancelButton {
                    Button(configuration.cancelButtonTitle) {
                        onCancel()
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(configuration.accentColor)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(configuration.accentColor.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                if configuration.showsSaveButton {
                    Button(configuration.saveButtonTitle) {
                        onConfirm()
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(configuration.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
            }
        }
        .padding(configuration.contentInsets)
        .background(configuration.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: configuration.cornerRadius))
        .onAppear {
            scrollToSelectedMonth()
        }
        .onChange(of: selectedDate) { _ in
            scrollToSelectedMonth()
        }
    }

    private func scrollToSelectedMonth() {
        calendarProxy.scrollToMonth(
            containing: selectedDate,
            scrollPosition: .centered,
            animated: false
        )
    }

    private func monthHeaderItem(for month: MonthComponents) -> AnyCalendarItemModel {
        let date = configuration.calendar.date(from: month.components) ?? selectedDate

        var properties = MonthHeaderView.InvariantViewProperties.base
        properties.font = .systemFont(ofSize: 22, weight: .semibold)
        properties.textColor = UIColor(configuration.monthTitleColor)

        let content = MonthHeaderView.Content(
            monthText: date.formatted(.dateTime.month(.wide).year()),
            accessibilityLabel: date.formatted(.dateTime.month(.wide).year())
        )

        return MonthHeaderView.calendarItemModel(
            invariantViewProperties: properties,
            content: content
        )
    }

    private func dayOfWeekItem(for weekdayIndex: Int) -> AnyCalendarItemModel {
        var properties = DayOfWeekView.InvariantViewProperties.base
        properties.font = .systemFont(ofSize: 16, weight: .medium)
        properties.textColor = UIColor(configuration.weekdayColor)

        let symbols = configuration.calendar.veryShortStandaloneWeekdaySymbols
        let symbol = symbols[weekdayIndex]

        let content = DayOfWeekView.Content(
            dayOfWeekText: symbol,
            accessibilityLabel: configuration.calendar.weekdaySymbols[weekdayIndex]
        )

        return DayOfWeekView.calendarItemModel(
            invariantViewProperties: properties,
            content: content
        )
    }

    private func dayItem(for day: DayComponents) -> AnyCalendarItemModel {
        guard let date = configuration.calendar.date(from: day.components) else {
            return defaultDayItem(for: day)
        }

        let isSelected = configuration.calendar.isDate(date, inSameDayAs: selectedDate)
        let isToday = configuration.calendar.isDateInToday(date)
        let isEnabled = isDateEnabled(date)

        var properties = DayView.InvariantViewProperties.baseInteractive
        properties.font = .systemFont(ofSize: 18, weight: .medium)
        properties.textColor = UIColor(dayTextColor(isSelected: isSelected, isEnabled: isEnabled))
        properties.backgroundShapeDrawingConfig = backgroundStyle(
            isSelected: isSelected,
            isToday: isToday,
            isEnabled: isEnabled
        )

        let content = DayView.Content(
            dayText: "\(day.day)",
            accessibilityLabel: date.formatted(.dateTime.weekday(.wide).month(.wide).day().year()),
            accessibilityHint: isSelected ? "Selected date" : nil
        )

        return DayView.calendarItemModel(
            invariantViewProperties: properties,
            content: content
        )
    }

    private func defaultDayItem(for day: DayComponents) -> AnyCalendarItemModel {
        DayView.calendarItemModel(
            invariantViewProperties: .baseNonInteractive,
            content: .init(
                dayText: "\(day.day)",
                accessibilityLabel: nil,
                accessibilityHint: nil
            )
        )
    }

    private func isDateEnabled(_ date: Date) -> Bool {
        if let minimumDate, date < configuration.calendar.startOfDay(for: minimumDate) {
            return false
        }

        if let maximumDate, date > configuration.calendar.startOfDay(for: maximumDate) {
            return false
        }

        if !configuration.allowsPastDates,
           date < configuration.calendar.startOfDay(for: Date()) {
            return false
        }

        if !configuration.allowsFutureDates,
           date > configuration.calendar.startOfDay(for: Date()) {
            return false
        }

        return true
    }

    private var minimumDate: Date? {
        configuration.minimumDate
    }

    private var maximumDate: Date? {
        configuration.maximumDate
    }

    private func dayTextColor(isSelected: Bool, isEnabled: Bool) -> Color {
        if !isEnabled {
            return configuration.disabledDayColor
        }

        if isSelected {
            return configuration.selectedTextColor
        }

        return configuration.dayTextColor
    }

    private func backgroundStyle(
        isSelected: Bool,
        isToday: Bool,
        isEnabled: Bool
    ) -> DrawingConfig {
        if !isEnabled {
            return .transparent
        }

        if isSelected {
            return DrawingConfig(
                fillColor: UIColor(configuration.selectedDayColor),
                borderColor: UIColor(configuration.selectedDayColor)
            )
        }

        if isToday {
            return DrawingConfig(
                fillColor: .clear,
                borderColor: UIColor(configuration.todayBorderColor),
                borderWidth: 1
            )
        }

        return .transparent
    }
}

struct TimePickerOverlayView: View {

    let configuration: CalendarConfiguration
    @Binding var selectedTime: Date
    let onConfirm: () -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Select Time")
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(configuration.monthTitleColor)
                .frame(maxWidth: .infinity, alignment: .leading)

            DatePicker(
                "",
                selection: $selectedTime,
                displayedComponents: [.hourAndMinute]
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            .frame(height: 180)
            .clipped()

            HStack(spacing: 12) {
                if configuration.showsCancelButton {
                    Button(configuration.cancelButtonTitle) {
                        onCancel()
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(configuration.accentColor)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(configuration.accentColor.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                if configuration.showsSaveButton {
                    Button(configuration.saveButtonTitle) {
                        onConfirm()
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(configuration.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
            }
        }
        .padding(configuration.contentInsets)
        .background(configuration.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: configuration.cornerRadius))
    }
}
