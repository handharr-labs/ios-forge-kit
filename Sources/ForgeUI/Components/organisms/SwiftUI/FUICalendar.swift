import SwiftUI

/// A pure-SwiftUI month-grid date picker. Navigates month-by-month, marks
/// today with a primary ring, fills the selected day in `primary`, and disables
/// dates outside `[minDate, maxDate]`. No dependencies — uses `Calendar.current`.
public struct FUICalendar: View {
    public let initialSelectedDate: Date
    public let onSelect: (Date) -> Void
    public let minDate: Date?
    public let maxDate: Date?

    @State private var displayMonth: Date
    @State private var selectedDate: Date

    private static let weekdays = ["S", "M", "T", "W", "T", "F", "S"]
    private let calendar = Calendar.current

    public init(
        selectedDate: Date,
        onSelect: @escaping (Date) -> Void,
        minDate: Date? = nil,
        maxDate: Date? = nil
    ) {
        self.initialSelectedDate = selectedDate
        self.onSelect = onSelect
        self.minDate = minDate
        self.maxDate = maxDate
        let cal = Calendar.current
        let comps = cal.dateComponents([.year, .month], from: selectedDate)
        _displayMonth = State(initialValue: cal.date(from: comps) ?? selectedDate)
        _selectedDate = State(initialValue: selectedDate)
    }

    // MARK: Helpers

    private var monthLabel: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: displayMonth)
    }

    private var daysInMonth: Int {
        calendar.range(of: .day, in: .month, for: displayMonth)?.count ?? 30
    }

    /// 0 = Sunday (weekday 1 in Calendar), shifted so Sunday is col 0.
    private var leadingBlanks: Int {
        let weekday = calendar.component(.weekday, from: displayMonth)
        return weekday - 1
    }

    private func date(for day: Int) -> Date {
        var comps = calendar.dateComponents([.year, .month], from: displayMonth)
        comps.day = day
        return calendar.date(from: comps) ?? displayMonth
    }

    private func isToday(_ d: Date) -> Bool {
        calendar.isDateInToday(d)
    }

    private func isSelected(_ d: Date) -> Bool {
        calendar.isDate(d, inSameDayAs: selectedDate)
    }

    private func isDisabled(_ d: Date) -> Bool {
        let dayStart = calendar.startOfDay(for: d)
        if let min = minDate, dayStart < calendar.startOfDay(for: min) { return true }
        if let max = maxDate, dayStart > calendar.startOfDay(for: max) { return true }
        return false
    }

    private func shiftMonth(by delta: Int) {
        guard let next = calendar.date(byAdding: .month, value: delta, to: displayMonth) else { return }
        displayMonth = next
    }

    // MARK: Body

    public var body: some View {
        VStack(spacing: Spacing.sm) {
            // Header
            HStack {
                Button {
                    shiftMonth(by: -1)
                } label: {
                    Image(systemName: FUIIcons.chevronLeft)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(FUIColor.textPrimary))
                        .frame(width: 36, height: 36)
                }
                .buttonStyle(.plain)

                Spacer()
                Text(monthLabel)
                    .font(.fuiSubtitle)
                    .foregroundColor(Color(FUIColor.textPrimary))
                Spacer()

                Button {
                    shiftMonth(by: 1)
                } label: {
                    Image(systemName: FUIIcons.chevronRight)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(FUIColor.textPrimary))
                        .frame(width: 36, height: 36)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, Spacing.xs)

            // Weekday row
            HStack(spacing: Spacing.none) {
                ForEach(Self.weekdays, id: \.self) { wd in
                    Text(wd)
                        .font(.fuiCaption)
                        .foregroundColor(Color(FUIColor.textSecondary))
                        .frame(maxWidth: .infinity)
                }
            }

            // Day grid
            let totalCells = leadingBlanks + daysInMonth
            let rows = Int(ceil(Double(totalCells) / 7.0))
            VStack(spacing: Spacing.xs) {
                ForEach(0..<rows, id: \.self) { row in
                    HStack(spacing: Spacing.none) {
                        ForEach(0..<7, id: \.self) { col in
                            let cellIndex = row * 7 + col
                            let day = cellIndex - leadingBlanks + 1
                            if day >= 1 && day <= daysInMonth {
                                let d = date(for: day)
                                DayCell(
                                    day: day,
                                    isToday: isToday(d),
                                    isSelected: isSelected(d),
                                    isDisabled: isDisabled(d)
                                ) {
                                    if !isDisabled(d) {
                                        selectedDate = d
                                        onSelect(d)
                                    }
                                }
                            } else {
                                Color.clear.frame(maxWidth: .infinity, minHeight: 36)
                            }
                        }
                    }
                }
            }
        }
        .padding(Spacing.md)
        .background(Color(FUIColor.surface))
        .cornerRadius(Radius.md)
    }
}

// MARK: - Day Cell

private struct DayCell: View {
    let day: Int
    let isToday: Bool
    let isSelected: Bool
    let isDisabled: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack {
                if isSelected {
                    Circle()
                        .fill(Color(FUIColor.primary))
                } else if isToday {
                    Circle()
                        .stroke(Color(FUIColor.primary), lineWidth: 1.5)
                }
                Text("\(day)")
                    .font(.fuiBody)
                    .foregroundColor(textColor)
            }
            .frame(maxWidth: .infinity, minHeight: 36)
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
    }

    private var textColor: Color {
        if isDisabled { return Color(FUIColor.textDisabled) }
        if isSelected { return Color(FUIColor.onPrimary) }
        return Color(FUIColor.textPrimary)
    }
}
