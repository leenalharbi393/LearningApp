import SwiftUI

/// The main screen: today's date, this week's progress, and the two stat cards.
struct ActivityView: View {
    @Environment(ActivityViewModel.self) private var viewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                weekStrip

                HStack(spacing: 12) {
                    StatCard(icon: "flame.fill", color: .learnOrange,
                             count: viewModel.learnedCount, label: "Learned")
                    StatCard(icon: "snowflake", color: .freezeBlue,
                             count: viewModel.freezesUsed, label: "Freezed")
                }

                Spacer()
            }
            .padding(.horizontal)
            .navigationTitle("Activity")
            .navigationSubtitle(viewModel.todayText)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { } label: { Image(systemName: "calendar") }
                }
                ToolbarSpacer(.fixed, placement: .topBarTrailing)
                ToolbarItem(placement: .topBarTrailing) {
                    Button { } label: { Image(systemName: "pencil.and.outline") }
                }
            }
        }
    }

    /// S M T W T F S with a DayCircle under each letter.
    private var weekStrip: some View {
        HStack {
            ForEach(viewModel.currentWeek, id: \.self) { date in
                VStack(spacing: 6) {
                    Text(viewModel.weekdayLetter(of: date))
                        .font(.caption2.weight(.semibold))

                    DayCircle(
                        day: viewModel.dayNumber(of: date),
                        status: viewModel.status(for: date),
                        isToday: viewModel.isToday(date)
                    )
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    let viewModel = ActivityViewModel()
    viewModel.startGoal(LearningGoal(topic: "Swift", duration: .week))
    viewModel.logLearned()

    return ActivityView()
        .environment(viewModel)
        .preferredColorScheme(.dark)
}
