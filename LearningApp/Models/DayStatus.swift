//
//  DayStatus.swift
//  LearningApp
//
//  Created by Leen Alharbi on 01/06/1448 AH.
//
import Foundation

var todayStatus: DayStatus?   // .learned, .freezed, or nil (nothing yet)
/// What the user did on a given day.
enum DayStatus: String, Codable {
    case learned
    case freezed
}
