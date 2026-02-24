import SwiftUI

struct TemperatureBar: View {
    let low: Measurement<UnitTemperature>
    let high: Measurement<UnitTemperature>
    let range: ClosedRange<Double>

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let totalSpan = range.upperBound - range.lowerBound
            let lowFraction = totalSpan > 0 ? (low.value - range.lowerBound) / totalSpan : 0
            let highFraction = totalSpan > 0 ? (high.value - range.lowerBound) / totalSpan : 1

            ZStack(alignment: .leading) {
                Capsule()
                    .fill(.quaternary)
                    .frame(height: 4)
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [.blue, .green, .yellow, .orange, .red],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: max(4, width * (highFraction - lowFraction)), height: 4)
                    .offset(x: width * lowFraction)
            }
        }
        .frame(height: 4)
    }
}
