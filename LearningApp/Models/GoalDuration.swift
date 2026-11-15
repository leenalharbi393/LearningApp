//
//  GoalDuration.swift
//  LearningApp
//
//  Created by Leen Alharbi on 30/05/1448 AH.
//

import Foundation

/// How long the user wants to keep learning their topic.
/// Why enum ? Fixed values
enum GoalDuration: String, CaseIterable, Codable {
    case week
    case month
    case year

    /// Text shown on the chips: "Week", "Month", "Year".
    var title: String {
        rawValue.capitalized
    }

    /// How many freezes the user gets for this duration.
    var freezeLimit: Int {
        switch self {
        case .week:  return 2
        case .month: return 8
        case .year:  return 96
        }
    }
}
