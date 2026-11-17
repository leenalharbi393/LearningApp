//
//  DayLog.swift
//  LearningApp
//
//  Created by Leen Alharbi on 01/06/1448 AH.
//
import Foundation

/// One logged day: which day it was, and what the user did.
struct DayLog: Codable, Identifiable, Equatable {
    let date: Date
    let status: DayStatus

    /// Each day can only be logged once, so the date itself is a unique ID.
    var id: Date { date }

    init(date: Date, status: DayStatus) {
        self.date = Calendar.app.startOfDay(for: date)
        self.status = status
    }
}
