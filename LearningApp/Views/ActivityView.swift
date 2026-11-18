import SwiftUI

/// The main screen: today's date, this week's progress, the stat cards,
/// and the two actions: log today as learned, or freeze it.
struct ActivityView: View {
    @Environment(ActivityViewModel.self) private var viewModel
    @Environment(\.scenePhase) private var scenePhase //I ADDED
    
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
                logButton
                Spacer()

                freezeSection
                    .padding(.bottom, 24)
            }
            .padding(.horizontal)
            .animation(.default, value: viewModel.todayStatus)
            //
            .onChange(of: scenePhase, initial: true) { _, phase in
                if phase == .active {
                    viewModel.refresh()
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .NSCalendarDayChanged)) { _ in
                viewModel.refresh()
            }//I ADDED
            .navigationTitle("Activity")
            .navigationSubtitle(viewModel.todayText)
            .toolbar {//
                #if DEBUG
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Button("+1 day") { viewModel.debugTimeTravel(hours: 24) }
                        Button("+33 hours") { viewModel.debugTimeTravel(hours: 33) }
                        Button("Reset all data", role: .destructive) { viewModel.debugReset() }
                        Button("+30 days") { viewModel.debugTimeTravel(hours: 24 * 30) }
                    
                    } label: {
                        Image(systemName: "ladybug")
                    }
                }
                #endif
                //I ADDED
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        CalendarView()
                    } label: {
                        Image(systemName: "calendar")
                    }
                }
                ToolbarSpacer(.fixed, placement: .topBarTrailing)
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        LearningGoalView(editor: GoalEditorViewModel(editing: viewModel.goal))
                    } label: {
                        Image(systemName: "pencil.and.outline")
                    }
                }
            }
        }
    }

    // MARK: - Week strip

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

    // MARK: - Big circle

    private var logButton: some View {
        Button {
            viewModel.logLearned()
        } label: {
            Text(viewModel.todayStatus == .learned ? "Logged as Learned" : "Log as Learned")
                .font(.title3.bold())
                .foregroundStyle(viewModel.canLogLearned ? .white : .secondary)
                .frame(width: 274, height: 274)
        }
        .buttonStyle(.plain)
        .glassEffect(
            viewModel.canLogLearned ? .regular.tint(.learnOrange).interactive() : .regular,
            in: .circle
        )
        .disabled(!viewModel.canLogLearned)
    }

    // MARK: - Freeze button + counter

    private var freezeSection: some View {
        VStack(spacing: 12) {
            Button {
                viewModel.logFreeze()
            } label: {
                Text(viewModel.canFreeze ? "Freeze for a day" : "Freezed for a day")
                    .font(.subheadline.weight(.medium))
                    .frame(width: 274, height: 48)
            }
            .buttonStyle(.glassProminent)
            .tint(.freezeBlue)
            .disabled(!viewModel.canFreeze)

            Text("\(viewModel.freezesUsed) out of \(viewModel.freezeLimit) Freezes used")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Previews (one per state)

#Preview("Default") {
    let viewModel = ActivityViewModel(store: nil)
    viewModel.startGoal(LearningGoal(topic: "Swift", duration: .week))
    return ActivityView()
        .environment(viewModel)
        .preferredColorScheme(.dark)
}

#Preview("Learned today") {
    let viewModel = ActivityViewModel(store: nil)
    viewModel.startGoal(LearningGoal(topic: "Swift", duration: .week))
    viewModel.logLearned()
    return ActivityView()
        .environment(viewModel)
        .preferredColorScheme(.dark)
}

#Preview("Freezed today") {
    let viewModel = ActivityViewModel(store: nil)
    viewModel.startGoal(LearningGoal(topic: "Swift", duration: .week))
    viewModel.logFreeze()
    return ActivityView()
        .environment(viewModel)
        .preferredColorScheme(.dark)
}
