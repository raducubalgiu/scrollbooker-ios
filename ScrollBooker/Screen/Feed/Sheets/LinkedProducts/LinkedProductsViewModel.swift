//
//  LinkedProductsViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.07.2026.
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class LinkedProductsViewModel {
    private(set) var viewState: FeatureState<LinkedProducts> = .idle
    private(set) var reviewAppointmentState: FeatureState<Appointment> = .idle
    private(set) var reviewDistanceKm: Double?

    var isSaving: Bool = false
    var isRefreshing: Bool = false

    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "LinkedProducts")

    private let postId: Int
    private let postUserId: Int
    let isVideoReview: Bool

    private let getPostLinkedProductsUseCase: GetPostLinkedProductsUseCase
    private let getAppointmentByUserAndPostUseCase: GetAppointmentByUserAndPostUseCase
    private let userLocationService: UserLocationService

    init(
        postId: Int,
        postUserId: Int,
        isVideoReview: Bool,
        getPostLinkedProductsUseCase: GetPostLinkedProductsUseCase,
        getAppointmentByUserAndPostUseCase: GetAppointmentByUserAndPostUseCase,
        userLocationService: UserLocationService
    ) {
        self.postId = postId
        self.postUserId = postUserId
        self.isVideoReview = isVideoReview
        self.getPostLinkedProductsUseCase = getPostLinkedProductsUseCase
        self.getAppointmentByUserAndPostUseCase = getAppointmentByUserAndPostUseCase
        self.userLocationService = userLocationService
    }

    func loadLinkedProducts() async {
        guard viewState.data == nil else { return }
        guard viewState != .loading else { return }

        viewState = .loading

        do {
            let userLocation = await userLocationService.currentLocation()
            let result = try await withLoading {
                try await getPostLinkedProductsUseCase(postId: postId, lat: userLocation?.lat, lng: userLocation?.lng)
            }
            viewState = .success(result)
        } catch {
            viewState = .error(logger.userMessage(for: error, context: "Fetching Linked Products for Post (\(self.postId))"))
        }
    }

    func refresh() async {
        guard !isRefreshing else { return }
        isRefreshing = true

        do {
            let userLocation = await userLocationService.currentLocation()
            let result = try await getPostLinkedProductsUseCase(postId: postId, lat: userLocation?.lat, lng: userLocation?.lng)
            viewState = .success(result)
        } catch {
            let message = logger.userMessage(for: error, context: "Refreshing Linked Products")
            if viewState.data == nil {
                viewState = .error(message)
            }
        }
        isRefreshing = false
    }

    /// Mirrors `loadLinkedProducts()`'s shape, for the video-review branch — this post is someone
    /// else's booking rather than a business's product catalog, so it fetches the appointment that
    /// booking actually was, instead of a product list.
    func loadReviewAppointment() async {
        guard reviewAppointmentState.data == nil else { return }
        guard reviewAppointmentState != .loading else { return }

        reviewAppointmentState = .loading

        do {
            let userLocation = await userLocationService.currentLocation()
            let result = try await withLoading {
                try await getAppointmentByUserAndPostUseCase(userId: postUserId, postId: postId, lat: userLocation?.lat, lng: userLocation?.lng)
            }
            reviewAppointmentState = .success(result)
            reviewDistanceKm = result.business.distanceKm
        } catch {
            reviewAppointmentState = .error(logger.userMessage(for: error, context: "Fetching Review Appointment for Post (\(self.postId))"))
        }
    }
}
