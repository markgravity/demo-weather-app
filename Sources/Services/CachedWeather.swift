import Foundation

final class CachedWeather: NSObject {
    let data: WeatherData
    let timestamp: Date
    let expiresAfter: TimeInterval

    var isExpired: Bool {
        Date().timeIntervalSince(timestamp) > expiresAfter
    }

    init(data: WeatherData, expiresAfter: TimeInterval = 300) {
        self.data = data
        self.timestamp = Date()
        self.expiresAfter = expiresAfter
    }
}
