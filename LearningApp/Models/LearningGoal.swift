//
//  LearningGoal.swift
//  LearningApp
//
//  Created by Leen Alharbi on 30/05/1448 AH.
//
import Foundation

/// What the user wants to learn, for how long, and since when.
struct LearningGoal: Codable, Equatable {
    var topic: String
    var duration: GoalDuration
    var startDate: Date = Date()

    /// The day this goal's period ends (start + 1 week / month / year).
    var endDate: Date {
        let component: Calendar.Component
        switch duration {
        case .week:  component = .weekOfYear
        case .month: component = .month
        case .year:  component = .year
        }
        return Calendar.current.date(byAdding: component, value: 1, to: startDate) ?? startDate
    }
}
