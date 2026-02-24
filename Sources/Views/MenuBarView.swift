#if os(macOS)
import SwiftUI
import ComposableArchitecture
import AppKit

struct MenuBarView: View {
    let store: StoreOf<AppFeature>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 8) {
                if let weather = viewStore.currentWeather {
                    HStack {
                        Image(systemName: weather.symbolName)
                            .symbolRenderingMode(.multicolor)
                        Text("\(weather.temperature, format: .measurement(width: .narrow))")
                            .font(.title3)
                    }
                    Text(weather.condition)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Divider()
                }
                Text(viewStore.locationName)
                    .font(.caption)
                Divider()
                Button("Refresh") { viewStore.send(.onAppear) }
                Button("Quit") { NSApplication.shared.terminate(nil) }
                    .keyboardShortcut("q")
            }
            .padding(8)
            .frame(width: 200)
        }
    }
}
#endif
