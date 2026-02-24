import SwiftUI

struct WeatherDetailsGrid: View {
    let details: [WeatherDetail]

    var body: some View {
        LazyVGrid(columns: [.init(), .init()], spacing: 12) {
            ForEach(details) { detail in
                VStack(alignment: .leading, spacing: 4) {
                    Label(detail.title, systemImage: detail.symbolName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(detail.value)
                        .font(.title3.bold())
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}
