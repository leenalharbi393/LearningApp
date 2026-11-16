import SwiftUI

/// A glass card showing an icon, "N day(s)", and a label.
struct StatCard: View {
    let icon: String
    let color: Color
    let count: Int
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundStyle(color)
                .font(.title3)

            Text("\(count) \(count == 1 ? "day" : "days")")
                .font(.subheadline.weight(.semibold))

            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .glassEffect(.regular, in: .rect(cornerRadius: 24))
    }
}

#Preview {
    HStack(spacing: 12) {
        StatCard(icon: "flame.fill", color: .learnOrange, count: 4, label: "Learned")
        StatCard(icon: "snowflake", color: .freezeBlue, count: 1, label: "Freezed")
    }
    .padding()
    .preferredColorScheme(.dark)
}
