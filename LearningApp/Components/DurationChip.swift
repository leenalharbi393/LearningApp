import SwiftUI

/// A single Week / Month / Year pill.
/// It doesn't own its selection: the parent tells it, and it reports taps back.
struct DurationChip: View {
    let duration: GoalDuration
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(duration.title)
                .font(.subheadline)
                .foregroundStyle(isSelected ? .white : .secondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
        }
        .buttonStyle(.plain)
        .glassEffect(
            isSelected ? .regular.tint(.orange).interactive() : .regular.interactive(),
            in: .capsule
        )
    }
}

#Preview {
    HStack {
        DurationChip(duration: .week, isSelected: true) {}
        DurationChip(duration: .month, isSelected: false) {}
        DurationChip(duration: .year, isSelected: false) {}
    }
    .padding()
    .preferredColorScheme(.dark)
}
