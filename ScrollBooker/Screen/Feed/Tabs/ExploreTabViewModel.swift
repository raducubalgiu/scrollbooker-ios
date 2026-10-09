//
//  ExploreTabViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 23.07.2026.
//

import SwiftUI
import Observation
import OSLog

@Observable
@MainActor
final class ExploreTabViewModel: BaseFeedViewModel {
    private let getExplorePostsUseCase: GetExplorePostsUseCase
    private let getAllServiceDomainsUseCase: GetAllServiceDomainsUseCase
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "Feed")

    private(set) var serviceDomainsState: FeatureState<[ServiceDomain]> = .idle
    private(set) var selectedServiceIds: Set<Int> = []
    private(set) var onlyVideoReviews: Bool = false

    var activeFiltersCount: Int {
        selectedServiceIds.count + (onlyVideoReviews ? 1 : 0)
    }

    init(
        getExplorePostsUseCase: GetExplorePostsUseCase,
        getAllServiceDomainsUseCase: GetAllServiceDomainsUseCase,
        playerManager: VideoPlayerManager,
        postInteractionStore: PostInteractionStore,
        userLocationService: UserLocationService
    ) {
        self.getExplorePostsUseCase = getExplorePostsUseCase
        self.getAllServiceDomainsUseCase = getAllServiceDomainsUseCase
        super.init(
            scopeKey: "explore_feed",
            playerManager: playerManager,
            postInteractionStore: postInteractionStore,
            userLocationService: userLocationService
        )
    }

    func initialLoad() async {
        await initialLoadIfNeeded { page, limit in
            try await self.getExplorePostsUseCase(
                page: page,
                limit: limit,
                serviceIds: Array(self.selectedServiceIds),
                onlyVideoReviews: self.onlyVideoReviews
            )
        }
    }

    func refreshPosts() async {
        await refresh { page, limit in
            try await self.getExplorePostsUseCase(
                page: page,
                limit: limit,
                serviceIds: Array(self.selectedServiceIds),
                onlyVideoReviews: self.onlyVideoReviews
            )
        }
    }

    func loadMore(currentPost: Post?) async {
        await loadMoreIfNeeded(currentPost: currentPost) { page, limit in
            try await self.getExplorePostsUseCase(
                page: page,
                limit: limit,
                serviceIds: Array(self.selectedServiceIds),
                onlyVideoReviews: self.onlyVideoReviews
            )
        }
    }

    func loadServiceDomains() async {
        guard serviceDomainsState == .idle else { return }
        serviceDomainsState = .loading

        do {
            let domains = try await withLoading {
                try await self.getAllServiceDomainsUseCase()
            }
            serviceDomainsState = .success(domains)
        } catch {
            serviceDomainsState = .error(logger.userMessage(for: error, context: "Loading Service Domains"))
        }
    }

    func applyFilters(serviceIds: Set<Int>, onlyVideoReviews: Bool) async {
        guard serviceIds != selectedServiceIds || onlyVideoReviews != self.onlyVideoReviews else { return }

        self.selectedServiceIds = serviceIds
        self.onlyVideoReviews = onlyVideoReviews

        await refreshPosts()
    }
}
