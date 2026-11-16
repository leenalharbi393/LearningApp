import SwiftUI

/// One day number, styled by what happened that day.
/// Used in the Activity week strip and the Calendar.
struct DayCircle: View {
    let day: Int
    let status: DayStatus?
    let isToday: Bool

    var body: some View {
        Text("\(day)")
            .font(.title3.weight(.medium))
            .foregroundStyle(textColor)
            .frame(width: 40, height: 40)
            .background(Circle().fill(backgroundColor))
    }

    private var textColor: Color {
        switch status {
        case .learned: return .learnOrange
        case .freezed: return .freezeBlue
        case nil:      return .white
        }
    }

    private var backgroundColor: Color {
        switch status {
        case .learned: return .learnOrange.opacity(0.2)
        case .freezed: return .freezeBlue.opacity(0.2)
        case nil:      return isToday ? .learnOrange : .clear
        }
    }
}

#Preview {
    HStack {
        DayCircle(day: 20, status: .learned, isToday: false)
        DayCircle(day: 23, status: .freezed, isToday: false)
        DayCircle(day: 24, status: nil, isToday: true)
        DayCircle(day: 25, status: nil, isToday: false)
    }
    .preferredColorScheme(.dark)
}
