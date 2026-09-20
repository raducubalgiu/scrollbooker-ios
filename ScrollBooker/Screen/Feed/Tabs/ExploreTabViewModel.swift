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
    private let likePostUseCase: LikePostUseCase
    private let unlikePostUseCase: UnlikePostUseCase
    private let bookmarkPostUseCase: BookmarkPostUseCase
    private let unbookmarkPostUseCase: UnbookmarkPostUseCase
    private let followUserUseCase: FollowUserUseCase
    private let unfollowUserUseCase: UnfollowUserUseCase
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
        likePostUseCase: LikePostUseCase,
        unlikePostUseCase: UnlikePostUseCase,
        bookmarkPostUseCase: BookmarkPostUseCase,
        unbookmarkPostUseCase: UnbookmarkPostUseCase,
        followUserUseCase: FollowUserUseCase,
        unfollowUserUseCase: UnfollowUserUseCase
    ) {
        self.getExplorePostsUseCase = getExplorePostsUseCase
        self.getAllServiceDomainsUseCase = getAllServiceDomainsUseCase
        self.likePostUseCase = likePostUseCase
        self.unlikePostUseCase = unlikePostUseCase
        self.bookmarkPostUseCase = bookmarkPostUseCase
        self.unbookmarkPostUseCase = unbookmarkPostUseCase
        self.followUserUseCase = followUserUseCase
        self.unfollowUserUseCase = unfollowUserUseCase
        super.init()
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

    func toggleLikePost(id: Int) async {
        await toggleLike(
            postId: id,
            likeAction: { [weak self] postId in
                guard let self else { throw APIError.invalidResponse }
                return try await self.likePostUseCase(id: postId)
            },
            unlikeAction: { [weak self] postId in
                guard let self else { throw APIError.invalidResponse }
                return try await self.unlikePostUseCase(id: postId)
            }
        )
    }

    func toggleBookmarkPost(id: Int) async {
        await toggleBookmark(
            postId: id,
            bookmarkAction: { [weak self] postId in
                guard let self else { throw APIError.invalidResponse }
                return try await self.bookmarkPostUseCase(id: postId)
            },
            unbookmarkAction: { [weak self] postId in
                guard let self else { throw APIError.invalidResponse }
                return try await self.unbookmarkPostUseCase(id: postId)
            }
        )
    }

    func toggleFollowPost(id: Int) async {
        await toggleFollow(
            postId: id,
            followAction: { [weak self] followeeId in
                guard let self else { throw APIError.invalidResponse }
                return try await self.followUserUseCase(followeeId: followeeId)
            },
            unfollowAction: { [weak self] followeeId in
                guard let self else { throw APIError.invalidResponse }
                return try await self.unfollowUserUseCase(followeeId: followeeId)
            }
        )
    }
}
