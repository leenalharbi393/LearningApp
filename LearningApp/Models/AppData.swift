import Foundation

/// Everything the app needs to remember between launches.
struct AppData: Codable {
    var goal: LearningGoal?
    var logs: [DayLog]
    var lastLoggedAt: Date?
    var streakStart: Date
}
