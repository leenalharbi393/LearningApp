import Foundation
import Observation

/// The shared brain of the app: owns the goal and the day logs,
/// answers questions about them, and performs the user's actions.
@Observable
final class ActivityViewModel {

    // MARK: - State

    /// nil = the user hasn't set a goal yet (still needs onboarding).
    private(set) var goal: LearningGoal?

    /// Every day the user has logged, across all goals.
    private(set) var logs: [DayLog] = []

    /// The app's idea of "now". Every time-based rule uses this, never Date() directly.
    private(set) var now: Date = Date()

    /// The exact moment of the last Learned or Freeze (nil = nothing logged yet).
    private(set) var lastLoggedAt: Date?

    /// When the current streak began: the goal's start, or the last reset.
    private(set) var streakStart: Date = Date()

    /// No activity for longer than this resets the streak.
    private let streakTimeLimit: TimeInterval = 32 * 60 * 60
    
    
    /// Where data is saved. nil = don't save (used by previews).
    private let store: DataStore?
    
    /// Debug time travel, in seconds (always 0 in normal use).
    private var timeOffset: TimeInterval = 0

    /// The real time right now, plus any debug time travel.
    private var currentTime: Date {
        Date().addingTimeInterval(timeOffset)
    }

    // MARK: - Init

    init(store: DataStore? = DataStore()) {
        self.store = store
        if let saved = store?.load() {
            goal = saved.goal
            logs = saved.logs
            lastLoggedAt = saved.lastLoggedAt
            streakStart = saved.streakStart
        }
    }
    //I ADDED
    
    
    // MARK: - Today

    /// .learned, .freezed, or nil if nothing is logged today yet.
    var todayStatus: DayStatus? {
        status(for: now)
    }

    /// What happened on a given day, or nil if nothing was logged.
    func status(for date: Date) -> DayStatus? {
        logs.first { Calendar.app.isDate($0.date, inSameDayAs: date) }?.status
    }

    // MARK: - Counts (the two stat cards)

    /// Learned days in the current streak.
    var learnedCount: Int {
        count(of: .learned, since: streakStart)
    }

    /// Freezes used during the current goal.
    var freezesUsed: Int {
        guard let goal else { return 0 }
        return count(of: .freezed, since: goal.startDate)
    }

    /// 2 / 8 / 96 depending on the goal's duration (0 if there's no goal).
    var freezeLimit: Int {
        goal?.duration.freezeLimit ?? 0
    }

    // MARK: - What the buttons are allowed to do

    var canLogLearned: Bool {
        goal != nil && goalState == .inProgress && todayStatus == nil
    }
    
    var canFreeze: Bool {
        canLogLearned && freezesUsed < freezeLimit
    }
    // MARK: - Goal state

    var goalState: GoalState {
        guard let goal else { return .inProgress }

        if learnedCount + freezesUsed >= goal.totalDays {
            return .completed
        }
        if isGoalPeriodOver(goal) {
            return .notMet
        }
        return .inProgress
    }

    /// True once today is on or after the goal's end day.
    private func isGoalPeriodOver(_ goal: LearningGoal) -> Bool {
        let calendar = Calendar.app
        return calendar.startOfDay(for: now) >= calendar.startOfDay(for: goal.endDate)
    }
    
    // MARK: - Actions

    func startGoal(_ newGoal: LearningGoal) {
        now = currentTime
        var started = newGoal
        started.startDate = now
        goal = started
        streakStart = now
        lastLoggedAt = nil
        save()
    }

    func logLearned() {
        refresh()
        guard canLogLearned else { return }
        record(.learned)
    }

    func logFreeze() {
        refresh()
        guard canFreeze else { return }
        record(.freezed)
    }

    /// Reads a fresh time and applies the time rules.
    /// Called on every action, when the screen appears, when the app returns, and at midnight.
    func refresh() {
        now = currentTime
        resetStreakIfNeeded()
    }

    // MARK: - Display

    /// "Thursday, 24 October"
    var todayText: String {
        let formatter = DateFormatter()
        formatter.calendar = .app
        formatter.locale = Calendar.app.locale
        formatter.dateFormat = "EEEE, d MMMM"
        return formatter.string(from: now)
    }

    /// The 7 dates of the current week, Sunday to Saturday.
    var currentWeek: [Date] {
        let calendar = Calendar.app
        let today = calendar.startOfDay(for: now)
        let weekday = calendar.component(.weekday, from: today)   // 1 = Sunday … 7 = Saturday
        let sunday = calendar.date(byAdding: .day, value: -(weekday - 1), to: today) ?? today
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: sunday) }
    }

    func dayNumber(of date: Date) -> Int {
        Calendar.app.component(.day, from: date)
    }

    /// "S", "M", "T"…
    func weekdayLetter(of date: Date) -> String {
        let weekday = Calendar.app.component(.weekday, from: date)
        return Calendar.app.veryShortWeekdaySymbols[weekday - 1]
    }

    func isToday(_ date: Date) -> Bool {
        Calendar.app.isDate(date, inSameDayAs: now)
    }

    // MARK: - Helpers

    /// Saves today's log and remembers the exact moment it happened.
    private func record(_ status: DayStatus) {
        logs.append(DayLog(loggedAt: now, status: status))
        lastLoggedAt = now
        save()
    }

    /// The 32-hour rule.
    private func resetStreakIfNeeded() {
        guard goal != nil else { return }
        let lastActivity = max(lastLoggedAt ?? streakStart, streakStart)
        if now.timeIntervalSince(lastActivity) > streakTimeLimit {
            streakStart = now
            save()
        }
    }

    /// Counts logs of one status made at or after an exact moment.
    private func count(of status: DayStatus, since start: Date) -> Int {
        logs.filter { $0.status == status && $0.loggedAt >= start }.count
    }
    
    /// Writes the current state to the device.
    private func save() {
        store?.save(AppData(
            goal: goal,
            logs: logs,
            lastLoggedAt: lastLoggedAt,
            streakStart: streakStart
        ))
    }
    
    // MARK: - Debug (only exists in test builds)

    #if DEBUG
    /// Moves the app's clock forward, to test multi-day rules without waiting.
    func debugTimeTravel(hours: Double) {
        timeOffset += hours * 60 * 60
        refresh()
    }

    /// Erases everything, cancels time travel, and returns to onboarding.
    func debugReset() {
        timeOffset = 0
        goal = nil
        logs = []
        lastLoggedAt = nil
        streakStart = Date()
        now = Date()
        save()
    }
    #endif
}
