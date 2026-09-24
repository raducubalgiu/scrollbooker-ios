//
//  BusinessProfileViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.07.2026.
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class BusinessProfileViewModel {
    private(set) var viewState: FeatureState<BusinessProfile> = .idle
    
    var isSaving: Bool = false
    var isRefreshing: Bool = false
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "BusinessProfile")
    
    private let username: String
    private let getBusinessProfileUseCase: GetBusinessProfileUseCase
    private let shareBusinessProfileUseCase: ShareBusinessProfileUseCase
    private let userLocationService: UserLocationService

    init(
        username: String,
        getBusinessProfileUseCase: GetBusinessProfileUseCase,
        shareBusinessProfileUseCase: ShareBusinessProfileUseCase,
        userLocationService: UserLocationService
    ) {
        self.username = username
        self.getBusinessProfileUseCase = getBusinessProfileUseCase
        self.shareBusinessProfileUseCase = shareBusinessProfileUseCase
        self.userLocationService = userLocationService
    }

    func loadBusinessProfile() async {
        guard viewState.data == nil else { return }
        guard viewState != .loading else { return }

        viewState = .loading

        do {
            let userLocation = await userLocationService.currentLocation()
            let result = try await withLoading {
                try await getBusinessProfileUseCase(username: username, lat: userLocation?.lat, lng: userLocation?.lng)
            }
            viewState = .success(result)
        } catch {
            viewState = .error(logger.userMessage(for: error, context: "Fetching Business Profile (\(self.username))"))
        }
    }

    func refresh() async {
        guard !isRefreshing else { return }
        isRefreshing = true

        do {
            let userLocation = await userLocationService.currentLocation()
            let result = try await getBusinessProfileUseCase(username: username, lat: userLocation?.lat, lng: userLocation?.lng)
            viewState = .success(result)
        } catch {
            let message = logger.userMessage(for: error, context: "Refreshing Business Profile")

            if viewState.data == nil {
                viewState = .error(message)
            }
        }
        isRefreshing = false
    }

    func shareBusinessProfile(channel: ShareChannelEnum) async {
        guard let businessId = viewState.data?.id else { return }

        do {
            _ = try await shareBusinessProfileUseCase(businessId: businessId, channel: channel)
        } catch {
            logger.error("ERROR: on Sharing Business Profile: \(error.localizedDescription, privacy: .public)")
        }
    }
}

