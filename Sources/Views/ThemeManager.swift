import SwiftUI

@Observable
final class ThemeManager {
    var colorScheme: ColorScheme? = nil
    var accentColor: Color = .blue
    var useDynamicBackground: Bool = true

    var backgroundGradient: LinearGradient {
        switch colorScheme {
        case .dark:
            return LinearGradient(
                colors: [.black, Color(hex: "1a1a2e")],
                startPoint: .top,
                endPoint: .bottom
            )
        default:
            return LinearGradient(
                colors: [Color(hex: "87CEEB"), Color(hex: "E0F7FA")],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        self.init(
            red: Double((rgbValue >> 16) & 0xFF) / 255.0,
            green: Double((rgbValue >> 8) & 0xFF) / 255.0,
            blue: Double(rgbValue & 0xFF) / 255.0
        )
    }
}
