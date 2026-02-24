import XCTest
@testable import AuroraWeather

final class WeatherServiceTests: XCTestCase {
    func testCurrentWeatherParsing() async throws {
        let service = MockWeatherService()
        let weather = try await service.currentWeather(for: .init())
        XCTAssertEqual(weather.condition, "Partly Cloudy")
    }

    func testHourlyForecastCount() async throws {
        let service = MockWeatherService()
        let forecast = try await service.hourlyForecast(for: .init())
        XCTAssertEqual(forecast.count, 24)
    }

    func testDailyForecastCount() async throws {
        let service = MockWeatherService()
        let forecast = try await service.dailyForecast(for: .init())
        XCTAssertEqual(forecast.count, 10)
    }
}
