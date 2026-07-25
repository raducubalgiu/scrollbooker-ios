//
//  ReviewsViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.07.2026.
//

import Foundation
import Observation

enum ReviewsUIState: Equatable {
    case idle
    case loading
    case success(ReviewSummary)
    case error(String)
    
    var summary: ReviewSummary? {
        if case .success(let summary) = self { return summary }
        return nil
    }
}

@Observable
@MainActor
final class ReviewsViewModel: HasLoadingState {
    private(set) var viewState: ReviewsUIState = .idle
    
    var isRefreshing: Bool = false
    private(set) var operationErrorMessage: String? = nil
    private(set) var isPerformingAction: Bool = false
    
    private(set) var writtenReviews: [Review] = []
    private(set) var videoReviews: [Post] = []
    
    private var currentWrittenPage = 1
    private var currentVideoPage = 1
    private let limit = 10
    
    private(set) var canLoadMoreWritten = true
    private(set) var canLoadMoreVideo = true
    
    private(set) var selectedRatings: Set<Int> = []
    
    var selectedTab: ReviewTab = .written {
        didSet {
            Task { await handleTabSelection() }
        }
    }
    
    var isLoading: Bool {
        get { if case .loading = viewState { return true }; return isPerformingAction }
        set { isPerformingAction = newValue }
    }
    
    var errorMessage: String? {
        get {
            if case .error(let msg) = viewState { return msg }
            return operationErrorMessage
        }
        set { operationErrorMessage = newValue }
    }
    
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
        guard viewState.summary == nil else { return }
        guard viewState != .loading else { return }
        
        viewState = .loading
        operationErrorMessage = nil
        
        do {
            let summary = try await getReviewSummaryUseCase(userId: userId)
            viewState = .success(summary)
            
            await fetchTabContent(for: selectedTab)
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            viewState = .error(message)
        }
    }
    
    private func handleTabSelection() async {
        if selectedTab == .written && writtenReviews.isEmpty && canLoadMoreWritten {
            await fetchTabContent(for: .written, isInitialFetchForTab: true)
        } else if selectedTab == .video && videoReviews.isEmpty && canLoadMoreVideo {
            await fetchTabContent(for: .video, isInitialFetchForTab: true)
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
        
        await fetchTabContent(for: selectedTab, isInitialFetchForTab: true)
    }

    func loadMoreWrittenReviews() async {
        guard canLoadMoreWritten, !isPerformingAction else { return }
        await fetchTabContent(for: .written)
    }

    func loadMoreVideoReviews() async {
        guard canLoadMoreVideo, !isPerformingAction else { return }
        await fetchTabContent(for: .video)
    }
    
    func refresh() async {
        guard !isRefreshing else { return }
        isRefreshing = true
        operationErrorMessage = nil
        
        currentWrittenPage = 1
        currentVideoPage = 1
        canLoadMoreWritten = true
        canLoadMoreVideo = true
        
        writtenReviews.removeAll()
        videoReviews.removeAll()
        
        do {
            let summary = try await getReviewSummaryUseCase(userId: userId)
            viewState = .success(summary)
            await fetchTabContent(for: selectedTab, isInitialFetchForTab: true)
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            if viewState.summary == nil {
                viewState = .error(message)
            } else {
                operationErrorMessage = message
            }
        }
        isRefreshing = false
    }

    private func fetchTabContent(for tab: ReviewTab, isInitialFetchForTab: Bool = false) async {
        if isInitialFetchForTab {
            isPerformingAction = true
        }
        operationErrorMessage = nil
        
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
                
                if currentWrittenPage == 1 {
                    self.writtenReviews = response.results
                } else {
                    self.writtenReviews.append(contentsOf: response.results)
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
                
                if currentVideoPage == 1 {
                    self.videoReviews = response.results
                } else {
                    self.videoReviews.append(contentsOf: response.results)
                }
                
                let loadedVideoCount = (currentVideoPage - 1) * limit + response.results.count
                self.canLoadMoreVideo = loadedVideoCount < response.count && !response.results.isEmpty
                
                if canLoadMoreVideo { currentVideoPage += 1 }
            }
        } catch {
            operationErrorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        }
        
        isPerformingAction = false
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
        
        operationErrorMessage = nil
        
        do {
            if currentlyLiked {
                _ = try await unlikeReviewUseCase(id: id)
            } else {
                _ = try await likeReviewUseCase(id: id)
            }
        } catch {
            if let currentIndex = writtenReviews.firstIndex(where: { $0.id == id }) {
                writtenReviews[currentIndex] = originalReview
            }
            operationErrorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        }
    }
}
