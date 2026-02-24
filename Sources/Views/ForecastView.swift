import SwiftUI

struct HourlyForecastRow: View {
    let hours: [HourlyForecast]

    var body: some View {
        VStack(alignment: .leading) {
            Label("Hourly Forecast", systemImage: "clock")
                .font(.headline)
                .foregroundStyle(.secondary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(hours) { hour in
                        VStack(spacing: 8) {
                            Text(hour.time, format: .dateTime.hour())
                                .font(.caption)
                            Image(systemName: hour.symbolName)
                                .symbolRenderingMode(.multicolor)
                                .font(.title2)
                            Text("\(hour.temperature, format: .measurement(width: .narrow))")
                                .font(.callout.bold())
                        }
                        .frame(width: 60)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

struct DailyForecastList: View {
    let days: [DailyForecast]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("10-Day Forecast", systemImage: "calendar")
                .font(.headline)
                .foregroundStyle(.secondary)

            ForEach(days) { day in
                HStack {
                    Text(day.date, format: .dateTime.weekday(.abbreviated))
                        .frame(width: 40, alignment: .leading)
                    Image(systemName: day.symbolName)
                        .symbolRenderingMode(.multicolor)
                        .frame(width: 30)
                    TemperatureBar(low: day.low, high: day.high, range: day.range)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}
