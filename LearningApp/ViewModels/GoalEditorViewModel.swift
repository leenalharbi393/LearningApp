import Foundation
import Observation

/// Holds the topic and duration being typed in GoalFormView, and turns them into a LearningGoal.
/// Used for creating (Onboarding) and editing (Learning Goal).
@Observable
final class GoalEditorViewModel {
    var topic: String
    var duration: GoalDuration

    /// The goal being edited, or nil when creating the first goal.
    private let originalGoal: LearningGoal?

    init(editing goal: LearningGoal? = nil) {
        originalGoal = goal
        topic = goal?.topic ?? ""
        duration = goal?.duration ?? .week
    }

    /// The topic isn't blank.
    var isValid: Bool {
        !trimmedTopic.isEmpty
    }

    /// When editing: did the user change anything? When creating: always true.
    var hasChanges: Bool {
        guard let originalGoal else { return true }
        return trimmedTopic != originalGoal.topic || duration != originalGoal.duration
    }

    /// Whether the main button (Start Learning / ✓) is allowed.
    var canSave: Bool {
        isValid && hasChanges
    }

    /// Builds the new goal, or returns nil if it isn't allowed.
    func makeGoal() -> LearningGoal? {
        guard canSave else { return nil }
        return LearningGoal(topic: trimmedTopic, duration: duration)
    }

    /// The topic without spaces or new lines at the start and end.
    private var trimmedTopic: String {
        topic.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
