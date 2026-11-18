import SwiftUI

/// Edit the learning goal. Changes are a draft until the user confirms.
struct LearningGoalView: View {
    @Environment(ActivityViewModel.self) private var activityViewModel
    @Environment(\.dismiss) private var dismiss

    /// The draft being edited (created by the screen that opens this one).
    @State var editor: GoalEditorViewModel

    /// Ask "your streak will start over?" before saving.
    /// False after a goal has ended, when there's no streak to lose.
    var confirmBeforeSaving = true

    /// UI-only state: is the confirmation alert showing?
    @State private var showUpdateAlert = false

    var body: some View {
        VStack(alignment: .leading) {
            GoalFormView(topic: $editor.topic, duration: $editor.duration)
            Spacer()
        }
        .padding()
        .navigationTitle("Learning Goal")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    if confirmBeforeSaving {
                        showUpdateAlert = true
                    } else {
                        save()
                    }
                } label: {
                    Image(systemName: "checkmark")
                }
                .buttonStyle(.glassProminent)
                .tint(.learnOrange)
                .disabled(!editor.canSave)
            }
        }
        .alert("Update goal", isPresented: $showUpdateAlert) {
            Button("Dismiss", role: .cancel) { }
            Button("Update", role: .confirm) { save() }
        } message: {
            Text("If you update now, your streak will start over.")
        }
    }

    /// Hands the new goal to the shared ViewModel and goes back.
    private func save() {
        if let newGoal = editor.makeGoal() {
            activityViewModel.startGoal(newGoal)
            dismiss()
        }
    }
}

#Preview {
    NavigationStack {
        LearningGoalView(
            editor: GoalEditorViewModel(editing: LearningGoal(topic: "Swift", duration: .week))
        )
    }
    .environment(ActivityViewModel(store: nil))
    .preferredColorScheme(.dark)
}
