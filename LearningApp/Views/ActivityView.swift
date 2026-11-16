//
//  ActivityView.swift
//  LearningApp
//
//  Created by Leen Alharbi on 06/06/1448 AH.
//
import SwiftUI

/// TEMPORARY test screen: shows the ViewModel's data so we can test the logic.
/// We'll replace this with the real design in step D.
struct ActivityView: View {
    @Environment(ActivityViewModel.self) private var viewModel

    var body: some View {
        VStack(spacing: 16) {
            Text("Learning: \(viewModel.goal?.topic ?? "-")")
                .font(.title2.bold())

            Text("Today: \(viewModel.todayStatus?.rawValue ?? "not logged")")
            Text("Learned: \(viewModel.learnedCount)")
            Text("Freezes: \(viewModel.freezesUsed) / \(viewModel.freezeLimit)")

            Button("Log as Learned") { viewModel.logLearned() }
                .buttonStyle(.glassProminent)
                .tint(.orange)
                .disabled(!viewModel.canLogLearned)

            Button("Freeze for a day") { viewModel.logFreeze() }
                .buttonStyle(.glassProminent)
                .tint(.cyan)
                .disabled(!viewModel.canFreeze)
        }
    }
}

#Preview {
    ActivityView()
        .environment(ActivityViewModel())
        .preferredColorScheme(.dark)
}
