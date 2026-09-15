//
//  CollectLocationPermissionViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import Foundation
import Observation
import CoreLocation
import OSLog

@Observable
@MainActor
final class CollectLocationPermissionViewModel: NSObject {
    private let session: SessionManager
    private let collectClientLocationPermissionUseCase: CollectClientLocationPermissionUseCase
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "Onboarding")
    private let locationManager = CLLocationManager()

    var isSaving = false
    var saveError: String?

    private var authorizationContinuation: CheckedContinuation<Void, Never>?

    init(session: SessionManager, collectClientLocationPermissionUseCase: CollectClientLocationPermissionUseCase) {
        self.session = session
        self.collectClientLocationPermissionUseCase = collectClientLocationPermissionUseCase
        super.init()
        locationManager.delegate = self
    }

    /// Cere permisiunea OS (dacă încă nu a fost decisă) și avansează pasul de onboarding
    /// indiferent de răspunsul userului — pasul e "soft", vezi docs/user-location-permission.md.
    func requestLocationPermission() async {
        if locationManager.authorizationStatus == .notDetermined {
            await withCheckedContinuation { continuation in
                authorizationContinuation = continuation
                locationManager.requestWhenInUseAuthorization()
            }
        }
        await collectLocationPermission()
    }

    func skip() async {
        await collectLocationPermission()
    }

    private func collectLocationPermission() async {
        isSaving = true
        saveError = nil

        do {
            let authState = try await withLoading {
                try await self.collectClientLocationPermissionUseCase()
            }
            session.updateAuthState(authState)
        } catch {
            saveError = logger.userMessage(for: error, context: "Collecting Client Location Permission")
        }

        isSaving = false
    }
}

extension CollectLocationPermissionViewModel: CLLocationManagerDelegate {
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            self.authorizationContinuation?.resume()
            self.authorizationContinuation = nil
        }
    }
}
