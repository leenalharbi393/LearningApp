//
//  OnboardingView.swift
//  LearningApp
//
//  Created by Leen Alharbi on 05/06/1448 AH.
//
import SwiftUI

/// First-launch screen: the user sets what to learn and for how long.
struct OnboardingView: View {
    @State private var viewModel = GoalEditorViewModel()
    let onStart: (LearningGoal) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(systemName: "flame.fill")
                .font(.system(size: 40))
                .foregroundStyle(.orange)
                .frame(maxWidth: .infinity)
                .padding(.top, 48)
                .padding(.bottom, 64)

            Text("Hello Learner")
                .font(.title.bold())

            Text("This app will help you learn everyday!")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.bottom, 32)

            GoalFormView(topic: $viewModel.topic, duration: $viewModel.duration)

            Spacer()

            VStack(spacing: 12) {
                Button("Start Learning") {
                    if let goal = viewModel.makeGoal() {
                        onStart(goal)
                    }
                }
                .buttonStyle(.glassProminent)
                .tint(.orange)
                .disabled(!viewModel.canSave)

                Text("You can edit your desire later")
                    .font(.caption2)
                    .foregroundStyle(.orange)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal)
    }
}

#Preview {
    OnboardingView { goal in
        print(goal)
    }
    .preferredColorScheme(.dark)
}
