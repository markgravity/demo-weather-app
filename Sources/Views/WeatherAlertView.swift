import SwiftUI
import UserNotifications

struct WeatherAlertView: View {
    let alerts: [WeatherAlert]
    @State private var expandedAlert: WeatherAlert.ID?

    var body: some View {
        if !alerts.isEmpty {
            VStack(spacing: 12) {
                ForEach(alerts) { alert in
                    AlertCard(
                        alert: alert,
                        isExpanded: expandedAlert == alert.id
                    ) {
                        withAnimation(.spring) {
                            expandedAlert = expandedAlert == alert.id ? nil : alert.id
                        }
                    }
                }
            }
        }
    }
}

struct AlertCard: View {
    let alert: WeatherAlert
    let isExpanded: Bool
    let onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: onTap) {
                HStack {
                    Image(systemName: iconName)
                        .foregroundStyle(severityColor)
                    Text(alert.title)
                        .font(.subheadline.bold())
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
            }
            .buttonStyle(.plain)

            if isExpanded {
                VStack(alignment: .leading, spacing: 4) {
                    Text(alert.description)
                        .font(.caption)
                    HStack {
                        Text("Source: \(alert.source)")
                        Spacer()
                        Text("Expires: \(alert.expires, format: .relative(presentation: .named))")
                    }
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding()
        .background(severityColor.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(severityColor.opacity(0.3), lineWidth: 1)
        )
    }

    private var iconName: String {
        switch alert.severity {
        case .extreme: "exclamationmark.triangle.fill"
        case .severe: "exclamationmark.triangle"
        case .moderate: "exclamationmark.circle.fill"
        case .minor: "info.circle"
        }
    }

    private var severityColor: Color {
        switch alert.severity {
        case .extreme: .red
        case .severe: .orange
        case .moderate: .yellow
        case .minor: .blue
        }
    }
}
