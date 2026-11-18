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
        return Calendar.app.date(byAdding: component, value: 1, to: startDate) ?? startDate
    }
    
    
    /// How many days this goal lasts: 7 for a week, 28–31 for a month, 365–366 for a year.
    var totalDays: Int {
        let calendar = Calendar.app
        let start = calendar.startOfDay(for: startDate)
        let end = calendar.startOfDay(for: endDate)
        return calendar.dateComponents([.day], from: start, to: end).day ?? 0
    }
    
    
    
}
