import SwiftUI

/// View-only history: every month from the first log to today,
/// with learned (orange) and freezed (blue) days.
struct CalendarView: View {
    @Environment(ActivityViewModel.self) private var activity

    private let columns = Array(repeating: GridItem(.flexible()), count: 7)

    /// Rebuilt from the shared data every time the screen redraws.
    private var model: CalendarViewModel {
        CalendarViewModel(
            firstDay: activity.logs.map(\.date).min() ?? activity.now,
            today: activity.now
        )
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 24) {
                ForEach(model.months, id: \.self) { month in
                    monthSection(month)
                    Divider()
                }
            }
            .padding()
        }
        .navigationTitle("Activities")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func monthSection(_ month: Date) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(model.title(for: month))
                .font(.headline)

            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(model.weekdayHeaders, id: \.self) { header in
                    Text(header)
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.secondary)
                }

                ForEach(Array(model.cells(for: month).enumerated()), id: \.offset) { _, date in
                    if let date {
                        DayCircle(
                            day: activity.dayNumber(of: date),
                            status: activity.status(for: date),
                            isToday: activity.isToday(date)
                        )
                    } else {
                        Color.clear.frame(height: 40)
                    }
                }
            }
        }
    }
}

#Preview {
    let viewModel = ActivityViewModel(store: nil)
    viewModel.startGoal(LearningGoal(topic: "Swift", duration: .month))
    viewModel.logLearned()
    viewModel.debugTimeTravel(hours: 24)
    viewModel.logFreeze()
    viewModel.debugTimeTravel(hours: 24)
    viewModel.logLearned()

    return NavigationStack {
        CalendarView()
    }
    .environment(viewModel)
    .preferredColorScheme(.dark)
}
