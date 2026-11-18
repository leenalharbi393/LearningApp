import Foundation

/// One logged day: exactly when the user logged, and what they did.
struct DayLog: Codable, Identifiable, Equatable {
    /// The exact moment the user tapped the button.
    let loggedAt: Date
    let status: DayStatus

    /// The calendar day of this log (midnight). Used for "which day?" questions.
    var date: Date {
        Calendar.app.startOfDay(for: loggedAt)
    }

    /// Each day can only be logged once, so the day itself is a unique ID.
    var id: Date { date }
}
