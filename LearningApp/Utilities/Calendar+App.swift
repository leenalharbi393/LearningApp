import Foundation

extension Calendar {
    /// The calendar the whole app uses: always Gregorian, in English,
    /// whatever calendar the user's phone is set to.
    static let app: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US")
        return calendar
    }()
}
