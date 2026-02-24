import SwiftUI
import ComposableArchitecture

struct HomeView: View {
    let store: StoreOf<AppFeature>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationStack {
                ScrollView {
                    VStack(spacing: 24) {
                        CurrentWeatherCard(weather: viewStore.currentWeather)
                        HourlyForecastRow(hours: viewStore.hourlyForecast)
                        DailyForecastList(days: viewStore.dailyForecast)
                        WeatherDetailsGrid(details: viewStore.weatherDetails)
                    }
                    .padding()
                }
                .navigationTitle(viewStore.locationName)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: { viewStore.send(.settingsTapped) }) {
                            Image(systemName: "gear")
                        }
                    }
                }
            }
            .task { viewStore.send(.onAppear) }
        }
    }
}

struct CurrentWeatherCard: View {
    let weather: CurrentWeather?

    var body: some View {
        if let weather {
            VStack(spacing: 8) {
                Image(systemName: weather.symbolName)
                    .font(.system(size: 64))
                    .symbolRenderingMode(.multicolor)
                Text("\(weather.temperature, format: .measurement(width: .narrow))")
                    .font(.system(size: 52, weight: .thin))
                Text(weather.condition)
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 32)
        }
    }
}
