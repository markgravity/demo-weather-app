import ComposableArchitecture
@preconcurrency import CoreLocation

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

    enum Action: Equatable {
        case onAppear
        case settingsTapped
        case weatherLoaded(CurrentWeather?, [HourlyForecast], [DailyForecast])
        case weatherFailed(String)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .none

            case .settingsTapped:
                return .none

            case let .weatherLoaded(current, hourly, daily):
                state.isLoading = false
                state.currentWeather = current
                state.hourlyForecast = hourly
                state.dailyForecast = daily
                return .none

            case let .weatherFailed(message):
                state.isLoading = false
                state.error = message
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

struct WeatherDetail: Identifiable, Equatable, Sendable {
    let id: UUID
    let title: String
    let value: String
    let symbolName: String
}
