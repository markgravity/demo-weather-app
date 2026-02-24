import Foundation
@preconcurrency import CoreLocation

protocol WeatherServiceProtocol: Sendable {
    func currentWeather(for location: CLLocation) async throws -> CurrentWeather
    func hourlyForecast(for location: CLLocation) async throws -> [HourlyForecast]
    func dailyForecast(for location: CLLocation) async throws -> [DailyForecast]
    func alerts(for location: CLLocation) async throws -> [WeatherAlert]
}

#if canImport(WeatherKit)
import WeatherKit

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
#endif

final class MockWeatherService: WeatherServiceProtocol {
    func currentWeather(for location: CLLocation) async throws -> CurrentWeather {
        CurrentWeather(
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
    }

    func hourlyForecast(for location: CLLocation) async throws -> [HourlyForecast] {
        (0..<24).map { i in
            HourlyForecast(
                id: UUID(),
                time: Calendar.current.date(byAdding: .hour, value: i, to: .now) ?? .now,
                temperature: .init(value: Double(72 - i % 10), unit: .fahrenheit),
                symbolName: "cloud.sun.fill",
                precipitationChance: 0.1
            )
        }
    }

    func dailyForecast(for location: CLLocation) async throws -> [DailyForecast] {
        (0..<10).map { i in
            DailyForecast(
                id: UUID(),
                date: Calendar.current.date(byAdding: .day, value: i, to: .now) ?? .now,
                high: .init(value: Double(78 + i), unit: .fahrenheit),
                low: .init(value: Double(58 + i), unit: .fahrenheit),
                symbolName: "sun.max.fill",
                precipitationChance: 0.05,
                range: 55...90
            )
        }
    }

    func alerts(for location: CLLocation) async throws -> [WeatherAlert] { [] }
}
