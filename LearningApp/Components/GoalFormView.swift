//
//  GoalFormView.swift
//  LearningApp
//
//  Created by Leen Alharbi on 02/06/1448 AH.
//
import SwiftUI

/// "I want to learn ___ in a [Week][Month][Year]".
/// Shared by Onboarding and Learning Goal. It edits data owned by its parent.
struct GoalFormView: View {
    @Binding var topic: String
    @Binding var duration: GoalDuration

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("I want to learn")
                .font(.subheadline)

            TextField("Swift", text: $topic)
                .font(.subheadline)

            Divider()
                .padding(.bottom, 12)

            Text("I want to learn it in a")
                .font(.subheadline)

            HStack(spacing: 8) {
                ForEach(GoalDuration.allCases, id: \.self) { option in
                    DurationChip(
                        duration: option,
                        isSelected: option == duration
                    ) {
                        duration = option
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var topic = ""
    @Previewable @State var duration: GoalDuration = .week

    GoalFormView(topic: $topic, duration: $duration)
        .padding()
        .preferredColorScheme(.dark)
}
