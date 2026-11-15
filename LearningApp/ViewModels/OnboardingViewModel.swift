//
//  OnboardingViewModel.swift
//  LearningApp
//
//  Created by Leen Alharbi on 02/06/1448 AH.
//
import Foundation
import Observation

/// Holds what the user is typing and choosing on Onboarding,
/// and turns it into a LearningGoal when valid.
@Observable
final class OnboardingViewModel {
    var topic: String = ""
    var duration: GoalDuration = .week

    /// The Start Learning button is only allowed when there's a real topic.
    var canStart: Bool {
        !trimmedTopic.isEmpty
    }

    /// Builds the goal, or returns nil if the input isn't valid.
    func makeGoal() -> LearningGoal? {
        guard canStart else { return nil }
        return LearningGoal(topic: trimmedTopic, duration: duration)
    }

    /// The topic without spaces or new lines at the start and end.
    private var trimmedTopic: String {
        topic.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
