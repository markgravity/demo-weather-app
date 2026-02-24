import Foundation
import WeatherKit
import CoreLocation

protocol WeatherServiceProtocol: Sendable {
    func currentWeather(for location: CLLocation) async throws -> CurrentWeather
    func hourlyForecast(for location: CLLocation) async throws -> [HourlyForecast]
    func dailyForecast(for location: CLLocation) async throws -> [DailyForecast]
    func alerts(for location: CLLocation) async throws -> [WeatherAlert]
}

final class LiveWeatherService: WeatherServiceProtocol {
    private let service = WeatherKit.WeatherService.shared

    func currentWeather(for location: CLLocation) async throws -> CurrentWeather {
        let weather = try await service.weather(for: location)
        let current = weather.currentWeather
        return CurrentWeather(
            temperature: current.temperature,
            feelsLike: current.apparentTemperature,
            condition: current.condition.description,
            symbolName: current.symbolName,
            humidity: current.humidity,
            windSpeed: current.wind.speed,
            uvIndex: current.uvIndex.value,
            visibility: current.visibility,
            pressure: current.pressure
        )
    }

    func hourlyForecast(for location: CLLocation) async throws -> [HourlyForecast] {
        let forecast = try await service.weather(for: location, including: .hourly)
        return forecast.prefix(24).map { hour in
            HourlyForecast(
                id: UUID(),
                time: hour.date,
                temperature: hour.temperature,
                symbolName: hour.symbolName,
                precipitationChance: hour.precipitationChance
            )
        }
    }

    func dailyForecast(for location: CLLocation) async throws -> [DailyForecast] {
        let forecast = try await service.weather(for: location, including: .daily)
        let temps = forecast.map { $0.highTemperature.value }
        let globalRange = (temps.min() ?? 0)...(temps.max() ?? 100)
        return forecast.prefix(10).map { day in
            DailyForecast(
                id: UUID(),
                date: day.date,
                high: day.highTemperature,
                low: day.lowTemperature,
                symbolName: day.symbolName,
                precipitationChance: day.precipitationChance,
                range: globalRange
            )
        }
    }

    func alerts(for location: CLLocation) async throws -> [WeatherAlert] {
        let weather = try await service.weather(for: location)
        return weather.weatherAlerts?.map { alert in
            WeatherAlert(
                id: UUID(),
                title: alert.summary,
                severity: .init(rawValue: alert.severity.rawValue) ?? .minor,
                description: alert.detailsURL.absoluteString,
                source: alert.source,
                expires: alert.metadata.expirationDate ?? .distantFuture
            )
        } ?? []
    }
}
