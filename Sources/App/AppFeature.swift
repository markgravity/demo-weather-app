import ComposableArchitecture
import CoreLocation

@Reducer
struct AppFeature {
    @ObservableState
    struct State: Equatable {
        var locationName: String = "Loading..."
        var currentWeather: CurrentWeather?
        var hourlyForecast: [HourlyForecast] = []
        var dailyForecast: [DailyForecast] = []
        var weatherDetails: [WeatherDetail] = []
        var alerts: [WeatherAlert] = []
        var savedLocations: [SavedLocation] = []
        var isLoading = false
        var error: String?
    }

    enum Action {
        case onAppear
        case settingsTapped
        case weatherResponse(Result<WeatherData, Error>)
        case locationUpdated(CLLocation)
        case alertsReceived([WeatherAlert])
    }

    @Dependency(\.weatherService) var weatherService
    @Dependency(\.locationService) var locationService

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { send in
                    let location = try await locationService.requestLocation()
                    await send(.locationUpdated(location))
                }

            case .settingsTapped:
                return .none

            case let .locationUpdated(location):
                return .run { send in
                    async let current = weatherService.currentWeather(for: location)
                    async let hourly = weatherService.hourlyForecast(for: location)
                    async let daily = weatherService.dailyForecast(for: location)
                    async let alerts = weatherService.alerts(for: location)
                    let data = try await WeatherData(
                        current: current,
                        hourly: hourly,
                        daily: daily,
                        alerts: alerts
                    )
                    await send(.weatherResponse(.success(data)))
                }

            case let .weatherResponse(.success(data)):
                state.isLoading = false
                state.currentWeather = data.current
                state.hourlyForecast = data.hourly
                state.dailyForecast = data.daily
                state.alerts = data.alerts
                return .none

            case let .weatherResponse(.failure(error)):
                state.isLoading = false
                state.error = error.localizedDescription
                return .none

            case let .alertsReceived(alerts):
                state.alerts = alerts
                return .none
            }
        }
    }
}

struct WeatherData: Equatable, Sendable {
    let current: CurrentWeather
    let hourly: [HourlyForecast]
    let daily: [DailyForecast]
    let alerts: [WeatherAlert]
}

struct WeatherDetail: Identifiable, Equatable {
    let id: UUID
    let title: String
    let value: String
    let symbolName: String
}
