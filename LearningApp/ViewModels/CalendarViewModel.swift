import Foundation

/// The month math for the Calendar screen: which months to show,
/// and how each month's grid is laid out. It owns no state, so it's a struct.
struct CalendarViewModel {
    let firstDay: Date
    let today: Date
    private let calendar = Calendar.app

    /// The first day of every month, from firstDay's month to today's month.
    var months: [Date] {
        guard let start = calendar.dateInterval(of: .month, for: firstDay)?.start,
              let end = calendar.dateInterval(of: .month, for: today)?.start
        else { return [] }

        var result: [Date] = []
        var month = start
        while month <= end {
            result.append(month)
            guard let next = calendar.date(byAdding: .month, value: 1, to: month) else { break }
            month = next
        }
        return result
    }

    /// "January 2026"
    func title(for month: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.locale = calendar.locale
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: month)
    }

    /// "SUN", "MON", … "SAT"
    var weekdayHeaders: [String] {
        calendar.shortWeekdaySymbols.map { $0.uppercased() }
    }

    /// The grid cells: empty cells (nil) before day 1, then one Date per day.
    func cells(for month: Date) -> [Date?] {
        guard let range = calendar.range(of: .day, in: .month, for: month) else { return [] }

        let firstWeekday = calendar.component(.weekday, from: month)   // 1 = Sunday … 7 = Saturday
        let blanks: [Date?] = Array(repeating: nil, count: firstWeekday - 1)

        let days = range.compactMap { day in
            calendar.date(byAdding: .day, value: day - 1, to: month)
        }
        return blanks + days.map { Optional($0) }
    }
}
