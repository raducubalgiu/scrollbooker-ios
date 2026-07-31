//
//  ReviewsViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.07.2026.
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class ReviewsViewModel {
    private(set) var viewState: FeatureState<ReviewSummary> = .idle
    private(set) var writtenReviews: [Review] = []
    private(set) var videoReviews: [Post] = []
    
    var isSaving: Bool = false
    var isRefreshing: Bool = false
    private(set) var isPaging: Bool = false
    
    var selectedTab: ReviewTab = .written {
        didSet {
            Task { await handleTabSelection() }
        }
    }
    private(set) var selectedRatings: Set<Int> = []
    
    private var currentWrittenPage = 1
    private var currentVideoPage = 1
    private let limit = 10
    
    private(set) var canLoadMoreWritten = true
    private(set) var canLoadMoreVideo = true
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "Reviews")
    
    private let userId: Int
    private let getWrittenReviewsUseCase: GetWrittenReviewsUseCase
    private let getReviewSummaryUseCase: GetReviewSummaryUseCase
    private let getVideoReviewsUseCase: GetVideoReviewsUseCase
    private let likeReviewUseCase: LikeReviewUseCase
    private let unlikeReviewUseCase: UnlikeReviewUseCase
    
    init(
        userId: Int,
        getWrittenReviewsUseCase: GetWrittenReviewsUseCase,
        getReviewSummaryUseCase: GetReviewSummaryUseCase,
        getVideoReviewsUseCase: GetVideoReviewsUseCase,
        likeReviewUseCase: LikeReviewUseCase,
        unlikeReviewUseCase: UnlikeReviewUseCase
    ) {
        self.userId = userId
        self.getWrittenReviewsUseCase = getWrittenReviewsUseCase
        self.getReviewSummaryUseCase = getReviewSummaryUseCase
        self.getVideoReviewsUseCase = getVideoReviewsUseCase
        self.likeReviewUseCase = likeReviewUseCase
        self.unlikeReviewUseCase = unlikeReviewUseCase
    }
    
    func loadInitialData() async {
        guard viewState.data == nil else { return }
        guard viewState != .loading else { return }
        
        viewState = .loading
        
        do {
            let summary = try await withLoading {
                try await getReviewSummaryUseCase(userId: userId)
            }
            viewState = .success(summary)
            
            await fetchTabContent(for: selectedTab, isFirstPage: true, isInitialFetchForTab: true)
        } catch {
            logger.error("ERROR: on Fetching Review Summary: \(error.localizedDescription)")
            viewState = .error("Something went wrong")
        }
    }

    private func handleTabSelection() async {
        if selectedTab == .written && writtenReviews.isEmpty && canLoadMoreWritten {
            await fetchTabContent(for: .written, isFirstPage: true, isInitialFetchForTab: true)
        } else if selectedTab == .video && videoReviews.isEmpty && canLoadMoreVideo {
            await fetchTabContent(for: .video, isFirstPage: true, isInitialFetchForTab: true)
        }
    }
    
    func toggleRatingFilter(_ rating: Int) async {
        if selectedRatings.contains(rating) {
            selectedRatings.remove(rating)
        } else {
            selectedRatings.insert(rating)
        }
        
        if selectedTab == .written {
            currentWrittenPage = 1
            canLoadMoreWritten = true
            writtenReviews.removeAll()
        } else {
            currentVideoPage = 1
            canLoadMoreVideo = true
            videoReviews.removeAll()
        }
        
        await fetchTabContent(for: selectedTab, isFirstPage: true, isInitialFetchForTab: true)
    }
    
    func loadMoreWrittenReviews(currentReview: Review?) async {
        guard canLoadMoreWritten, !isPaging, !isRefreshing, viewState != .loading else { return }
        guard currentReview?.id == writtenReviews.last?.id else { return }
        
        isPaging = true
        await fetchTabContent(for: .written, isFirstPage: false)
        isPaging = false
    }

    func loadMoreVideoReviews(currentPost: Post?) async {
        guard canLoadMoreVideo, !isPaging, !isRefreshing, viewState != .loading else { return }
        guard currentPost?.id == videoReviews.last?.id else { return }
        
        isPaging = true
        await fetchTabContent(for: .video, isFirstPage: false)
        isPaging = false
    }
    
    func refresh() async {
        guard !isRefreshing else { return }
        isRefreshing = true
        
        currentWrittenPage = 1
        currentVideoPage = 1
        canLoadMoreWritten = true
        canLoadMoreVideo = true
        
        writtenReviews.removeAll()
        videoReviews.removeAll()
        
        do {
            let summary = try await getReviewSummaryUseCase(userId: userId)
            viewState = .success(summary)

            await fetchTabContent(for: selectedTab, isFirstPage: true, isInitialFetchForTab: true)
        } catch {
            logger.error("ERROR: on Refreshing Reviews: \(error.localizedDescription)")
            if viewState.data == nil {
                viewState = .error("Something went wrong")
            }
        }
        isRefreshing = false
    }

    private func fetchTabContent(for tab: ReviewTab, isFirstPage: Bool, isInitialFetchForTab: Bool = false) async {
        if isInitialFetchForTab {
            isSaving = true
        }
        
        let ratingsFilter = selectedRatings.isEmpty ? nil : Array(selectedRatings)
        
        do {
            switch tab {
            case .written:
                let response = try await getWrittenReviewsUseCase(
                    userId: userId,
                    page: currentWrittenPage,
                    limit: limit,
                    ratings: ratingsFilter
                )
                
                if isFirstPage {
                    self.writtenReviews = response.results
                } else {
                    let existingIds = Set(self.writtenReviews.map(\.id))
                    let uniqueItems = response.results.filter { !existingIds.contains($0.id) }
                    self.writtenReviews.append(contentsOf: uniqueItems)
                }
                
                let loadedCount = (currentWrittenPage - 1) * limit + response.results.count
                self.canLoadMoreWritten = loadedCount < response.count && !response.results.isEmpty
                
                if canLoadMoreWritten { currentWrittenPage += 1 }
                
            case .video:
                let response = try await getVideoReviewsUseCase(
                    userId: userId,
                    page: currentVideoPage,
                    limit: limit
                )
                
                if isFirstPage {
                    self.videoReviews = response.results
                } else {
                    let existingIds = Set(self.videoReviews.map(\.id))
                    let uniqueItems = response.results.filter { !existingIds.contains($0.id) }
                    self.videoReviews.append(contentsOf: uniqueItems)
                }
                
                let loadedVideoCount = (currentVideoPage - 1) * limit + response.results.count
                self.canLoadMoreVideo = loadedVideoCount < response.count && !response.results.isEmpty
                
                if canLoadMoreVideo { currentVideoPage += 1 }
            }
        } catch {
            logger.error("ERROR: on Fetching \(tab == .written ? "Written" : "Video") Reviews page: \(error.localizedDescription)")
        }
        
        isSaving = false
    }
    
    func toggleLikeWrittenReview(id: Int) async {
        guard let index = writtenReviews.firstIndex(where: { $0.id == id }) else { return }
        
        let originalReview = writtenReviews[index]
        let currentlyLiked = originalReview.isLiked
        
        let newIsLiked = !currentlyLiked
        let newLikeCount = currentlyLiked ? max(0, originalReview.likeCount - 1) : originalReview.likeCount + 1
        
        writtenReviews[index] = originalReview.copy(
            likeCount: newLikeCount,
            isLiked: newIsLiked
        )
        
        do {
            if currentlyLiked {
                _ = try await unlikeReviewUseCase(id: id)
            } else {
                _ = try await likeReviewUseCase(id: id)
            }
        } catch {
            logger.error("ERROR: on Toggling Like for Review \(id): \(error.localizedDescription)")

            if let currentIndex = writtenReviews.firstIndex(where: { $0.id == id }) {
                writtenReviews[currentIndex] = originalReview
            }
        }
    }
}
