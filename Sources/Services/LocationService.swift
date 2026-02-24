import Foundation
@preconcurrency import CoreLocation

final class LocationService: Sendable {
    func requestLocation() async throws -> CLLocation {
        let updates = CLLocationUpdate.liveUpdates()
        for try await update in updates {
            if let location = update.location {
                return location
            }
        }
        throw LocationError.unavailable
    }

    func requestAuthorization() async -> CLAuthorizationStatus {
        let manager = CLLocationManager()
        if manager.authorizationStatus == .notDetermined {
            manager.requestWhenInUseAuthorization()
            try? await Task.sleep(for: .seconds(0.5))
        }
        return manager.authorizationStatus
    }

    enum LocationError: LocalizedError {
        case unavailable
        case unauthorized

        var errorDescription: String? {
            switch self {
            case .unavailable: "Location data is currently unavailable."
            case .unauthorized: "Location access is required. Please enable it in Settings."
            }
        }
    }
}
