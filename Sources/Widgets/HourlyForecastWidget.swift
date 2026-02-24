import WidgetKit
import SwiftUI

struct HourlyForecastWidget: Widget {
    let kind = "HourlyForecastWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HourlyForecastProvider()) { entry in
            HourlyForecastWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Hourly Forecast")
        .description("See the next 6 hours at a glance.")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

struct HourlyForecastEntry: TimelineEntry {
    let date: Date
    let locationName: String
    let hours: [WidgetHourData]
}

struct WidgetHourData: Identifiable {
    let id = UUID()
    let time: Date
    let temperature: Int
    let symbolName: String
    let precipChance: Int
}

struct HourlyForecastProvider: TimelineProvider {
    func placeholder(in context: Context) -> HourlyForecastEntry {
        .init(date: .now, locationName: "San Francisco", hours: Self.sampleHours)
    }

    func getSnapshot(in context: Context, completion: @escaping (HourlyForecastEntry) -> Void) {
        completion(placeholder(in: context))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<HourlyForecastEntry>) -> Void) {
        let entry = HourlyForecastEntry(date: .now, locationName: "San Francisco", hours: Self.sampleHours)
        let timeline = Timeline(entries: [entry], policy: .after(.now.addingTimeInterval(900)))
        completion(timeline)
    }

    static var sampleHours: [WidgetHourData] {
        (0..<6).map { i in
            WidgetHourData(
                time: Calendar.current.date(byAdding: .hour, value: i, to: .now) ?? .now,
                temperature: 72 - i,
                symbolName: ["sun.max.fill", "cloud.sun.fill", "cloud.fill", "cloud.drizzle.fill", "cloud.fill", "sun.max.fill"][i],
                precipChance: [0, 10, 25, 60, 40, 5][i]
            )
        }
    }
}

struct HourlyForecastWidgetView: View {
    let entry: HourlyForecastEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "location.fill")
                    .font(.caption2)
                Text(entry.locationName)
                    .font(.caption.bold())
                Spacer()
                Text("Hourly")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            HStack(spacing: 0) {
                ForEach(entry.hours) { hour in
                    VStack(spacing: 4) {
                        Text(hour.time, format: .dateTime.hour())
                            .font(.caption2)
                        Image(systemName: hour.symbolName)
                            .symbolRenderingMode(.multicolor)
                        Text("\(hour.temperature)°")
                            .font(.callout.bold())
                        if hour.precipChance > 0 {
                            Text("\(hour.precipChance)%")
                                .font(.caption2)
                                .foregroundStyle(.cyan)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
}
