import Foundation
import CoreLocation

final class LocationService: NSObject, CLLocationManagerDelegate, Sendable {
    private let manager = CLLocationManager()

    func requestLocation() async throws -> CLLocation {
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            manager.requestLocation()
        }
    }

    private var continuation: CheckedContinuation<CLLocation, Error>?

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        continuation?.resume(returning: location)
        continuation = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        continuation?.resume(throwing: error)
        continuation = nil
    }
}
