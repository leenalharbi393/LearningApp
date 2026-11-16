import SwiftUI

@main
struct LearningApp: App {
    /// The one shared ViewModel for the whole app.
    @State private var activityViewModel = ActivityViewModel()

    var body: some Scene {
        WindowGroup {
            Group {
                if activityViewModel.goal == nil {
                    OnboardingView { goal in
                        activityViewModel.startGoal(goal)
                    }
                } else {
                    ActivityView()
                }
            }
            .environment(activityViewModel)
            .preferredColorScheme(.dark)
        }
    }
}
