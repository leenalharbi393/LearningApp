//
//  ActivityViewModel.swift
//  LearningApp
//
//  Created by Leen Alharbi on 05/06/1448 AH.
//
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

    // MARK: - Today

    /// .learned, .freezed, or nil if nothing is logged today yet.
    var todayStatus: DayStatus? {
        status(for: Date())
    }

    /// What happened on a given day, or nil if nothing was logged.
    func status(for date: Date) -> DayStatus? {
        logs.first { Calendar.app.isDate($0.date, inSameDayAs: date) }?.status
    }

    // MARK: - Counts (the two stat cards)

    var learnedCount: Int { count(of: .learned) }
    var freezesUsed: Int { count(of: .freezed) }

    /// 2 / 8 / 96 depending on the goal's duration (0 if there's no goal).
    var freezeLimit: Int {
        goal?.duration.freezeLimit ?? 0
    }

    // MARK: - What the buttons are allowed to do

    var canLogLearned: Bool {
        goal != nil && todayStatus == nil
    }

    var canFreeze: Bool {
        canLogLearned && freezesUsed < freezeLimit
    }

    // MARK: - Actions

    func startGoal(_ newGoal: LearningGoal) {
        goal = newGoal
    }

    func logLearned() {
        guard canLogLearned else { return }
        logs.append(DayLog(date: Date(), status: .learned))
    }

    func logFreeze() {
        guard canFreeze else { return }
        logs.append(DayLog(date: Date(), status: .freezed))
    }

    
    // MARK: - Display

    /// "Thursday, 24 October"
    var todayText: String {
        let formatter = DateFormatter()
        formatter.calendar = .app
        formatter.locale = Calendar.app.locale
        formatter.dateFormat = "EEEE, d MMMM"
        return formatter.string(from: Date())
    }

    /// The 7 dates of the current week, Sunday to Saturday.
    var currentWeek: [Date] {
        let calendar = Calendar.app
        let today = calendar.startOfDay(for: Date())
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
        Calendar.app.isDateInToday(date)
    }
    
    // MARK: - Helpers

    /// Counts logs of one status since the current goal started.
    private func count(of status: DayStatus) -> Int {
        guard let goal else { return 0 }
        let start = Calendar.app.startOfDay(for: goal.startDate)
        return logs.filter { $0.status == status && $0.date >= start }.count
    }
}
