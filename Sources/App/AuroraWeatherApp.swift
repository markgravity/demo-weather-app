import SwiftUI
import ComposableArchitecture

@main
struct AuroraWeatherApp: App {
    let store = Store(initialState: AppFeature.State()) {
        AppFeature()
    }

    var body: some Scene {
        WindowGroup {
            HomeView(store: store)
        }
        #if os(macOS)
        MenuBarExtra("Aurora Weather", systemImage: "cloud.sun.fill") {
            MenuBarView(store: store)
        }
        #endif
    }
}
