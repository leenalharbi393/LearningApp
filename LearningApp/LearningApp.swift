
import SwiftUI

@main
struct LearningApp: App {
    var body: some Scene {
        WindowGroup {
            OnboardingView { goal in
                print("Goal created:", goal)
            }
            .preferredColorScheme(.dark)
        }
    }
}
