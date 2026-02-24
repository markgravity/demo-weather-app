import SwiftUI

struct OfflineBanner: View {
    @Environment(NetworkMonitor.self) private var networkMonitor

    var body: some View {
        if !networkMonitor.isConnected {
            HStack(spacing: 8) {
                Image(systemName: "wifi.slash")
                Text("No internet connection. Showing cached data.")
                    .font(.caption)
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(.red.gradient, in: Capsule())
            .transition(.move(edge: .top).combined(with: .opacity))
            .animation(.spring, value: networkMonitor.isConnected)
        }
    }
}
