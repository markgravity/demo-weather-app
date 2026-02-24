import Foundation

struct CurrentWeather: Equatable, Sendable {
    let temperature: Measurement<UnitTemperature>
    let feelsLike: Measurement<UnitTemperature>
    let condition: String
    let symbolName: String
    let humidity: Double
    let windSpeed: Measurement<UnitSpeed>
    let uvIndex: Int
    let visibility: Measurement<UnitLength>
    let pressure: Measurement<UnitPressure>
}

struct HourlyForecast: Identifiable, Equatable, Sendable {
    let id: UUID
    let time: Date
    let temperature: Measurement<UnitTemperature>
    let symbolName: String
    let precipitationChance: Double
}

struct DailyForecast: Identifiable, Equatable, Sendable {
    let id: UUID
    let date: Date
    let high: Measurement<UnitTemperature>
    let low: Measurement<UnitTemperature>
    let symbolName: String
    let precipitationChance: Double
    let range: ClosedRange<Double>
}

struct WeatherAlert: Identifiable, Equatable, Sendable {
    let id: UUID
    let title: String
    let severity: Severity
    let description: String
    let source: String
    let expires: Date

    enum Severity: String, Sendable {
        case minor, moderate, severe, extreme
    }
}

struct SavedLocation: Identifiable, Equatable, Codable, Sendable {
    let id: UUID
    let name: String
    let latitude: Double
    let longitude: Double
}
