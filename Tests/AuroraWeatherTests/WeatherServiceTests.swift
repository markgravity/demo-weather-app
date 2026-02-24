import XCTest
@testable import AuroraWeather

final class WeatherServiceTests: XCTestCase {
    func testCurrentWeatherInit() {
        let weather = CurrentWeather(
            temperature: .init(value: 72, unit: .fahrenheit),
            feelsLike: .init(value: 70, unit: .fahrenheit),
            condition: "Partly Cloudy",
            symbolName: "cloud.sun.fill",
            humidity: 0.65,
            windSpeed: .init(value: 10, unit: .milesPerHour),
            uvIndex: 5,
            visibility: .init(value: 10, unit: .miles),
            pressure: .init(value: 1013, unit: .hectopascals)
        )
        XCTAssertEqual(weather.condition, "Partly Cloudy")
        XCTAssertEqual(weather.uvIndex, 5)
    }

    func testDailyForecastEquatable() {
        let day = DailyForecast(
            id: UUID(),
            date: .now,
            high: .init(value: 80, unit: .fahrenheit),
            low: .init(value: 60, unit: .fahrenheit),
            symbolName: "sun.max.fill",
            precipitationChance: 0.1,
            range: 55...85
        )
        XCTAssertEqual(day, day)
    }

    func testSavedLocationCodable() throws {
        let location = SavedLocation(
            id: UUID(),
            name: "San Francisco",
            latitude: 37.7749,
            longitude: -122.4194
        )
        let data = try JSONEncoder().encode(location)
        let decoded = try JSONDecoder().decode(SavedLocation.self, from: data)
        XCTAssertEqual(location, decoded)
    }
}
