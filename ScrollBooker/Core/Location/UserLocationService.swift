//
//  UserLocationService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import Foundation
import CoreLocation
import Observation

@Observable
@MainActor
final class UserLocationService: NSObject {
    private(set) var authorizationStatus: CLAuthorizationStatus
    private(set) var lastLocation: BusinessCoordinates?

    private let locationManager = CLLocationManager()
    private var lastFetchDate: Date?
    private var inFlightTask: Task<BusinessCoordinates?, Never>?
    private var pendingResume: ((BusinessCoordinates?) -> Void)?

    private let cacheTTL: TimeInterval = 600
    private let fetchTimeout: Duration = .seconds(5)

    override init() {
        self.authorizationStatus = .notDetermined
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        self.authorizationStatus = locationManager.authorizationStatus
    }

    /// Poziția curentă a userului, din cache dacă e suficient de recentă, altfel dintr-un
    /// singur fix nou (`requestLocation`, nu urmărire continuă). Întoarce `nil` rapid dacă
    /// permisiunea nu e acordată, în loc să blocheze ecranul apelant.
    func currentLocation() async -> BusinessCoordinates? {
        if let lastLocation, let lastFetchDate, Date().timeIntervalSince(lastFetchDate) < cacheTTL {
            return lastLocation
        }

        if let inFlightTask {
            return await inFlightTask.value
        }

        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            return nil
        }

        let task = Task { await self.fetchLocation() }
        inFlightTask = task
        let result = await task.value
        inFlightTask = nil
        return result
    }

    private func fetchLocation() async -> BusinessCoordinates? {
        await withCheckedContinuation { continuation in
            var didResume = false
            pendingResume = { [weak self] value in
                guard !didResume else { return }
                didResume = true
                self?.pendingResume = nil
                continuation.resume(returning: value)
            }

            locationManager.requestLocation()

            Task { [weak self] in
                try? await Task.sleep(for: self?.fetchTimeout ?? .seconds(5))
                self?.pendingResume?(nil)
            }
        }
    }
}

extension UserLocationService: CLLocationManagerDelegate {
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        Task { @MainActor in
            self.authorizationStatus = status
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let coordinates = BusinessCoordinates(
            lat: location.coordinate.latitude,
            lng: location.coordinate.longitude
        )

        Task { @MainActor in
            self.lastLocation = coordinates
            self.lastFetchDate = Date()
            self.pendingResume?(coordinates)
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            self.pendingResume?(nil)
        }
    }
}
