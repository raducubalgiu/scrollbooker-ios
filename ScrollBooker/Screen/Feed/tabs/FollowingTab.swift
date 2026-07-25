//
//  FollowingTab.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 23.07.2026.
//

import SwiftUI

struct FollowingTab: View {
    var viewModel: FollowingTabViewModel
    let makeCommentsVM: (Int) -> CommentsViewModel
    let makeLinkedProductsVM: (Int) -> LinkedProductsViewModel
    let makeReviewsVM: (Int) -> ReviewsViewModel
    var onNavigateToUserProfile: (ProfileNavigationParams) -> Void
    let onNavigateToBooking: (BookingNavigationParams) -> Void
    
    @State private var currentIndex: Int? = 0
    @State private var activeSheet: FeedSheetType? = nil
    
    @State private var commentsCache = ViewModelCache<Int, CommentsViewModel>()
    @State private var linkedProductsCache = ViewModelCache<Int, LinkedProductsViewModel>()
    @State private var reviewsCache = ViewModelCache<Int, ReviewsViewModel>()
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            switch viewModel.viewState {
                case .idle, .loading:
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black)
                    
                case .empty:
                    NoDataView(
                        title: "Postari",
                        message: "Nu există postări",
                        systemImage: "video.splash"
                    )
                    
                case .error(let message):
                    ErrorView(message: message) {
                        Task { await viewModel.refreshPosts() }
                    }
                    
                case .success(_):
                    PostsSuccessView(viewModel: viewModel, currentIndex: $currentIndex)
                }
        }
        .ignoresSafeArea(.all)
        .environment(\.feedActions, FeedActions(
            onNavigateToUserProfile: onNavigateToUserProfile,
            onNavigateToBooking: onNavigateToBooking,
            onOpenReviewsSheet: { activeSheet = .reviews(userId: $0) },
            onOpenLinkedProductsSheet: { activeSheet = .linkedProducts(postId: $0) },
            onOpenCommentsSheet: { activeSheet = .comments(postId: $0) },
            onLike: { id in Task { await viewModel.toggleLikePost(id: id) } },
            onBookmark: { id in Task { await viewModel.toggleBookmarkPost(id: id) } }
        ))
        .sheet(item: $activeSheet) { sheetType in
            switch sheetType {
            case .comments(let postId):
                CommentsSheetView(
                    viewModel: commentsCache.viewModel(for: postId, make: makeCommentsVM),
                    onNavigateToUserProfile: onNavigateToUserProfile
                )
                .presentationDetents([.fraction(0.7), .large])
                .presentationDragIndicator(.visible)

            case .reviews(let userId):
                ReviewsSheetView(
                    viewModel: reviewsCache.viewModel(for: userId, make: makeReviewsVM)
                )
                .presentationDetents([.fraction(0.7), .large])
                    .presentationDragIndicator(.visible)

            case .linkedProducts(let postId):
                LinkedProductsSheetView(
                    viewModel: linkedProductsCache.viewModel(for: postId, make: makeLinkedProductsVM),
                    onNavigateToBooking: onNavigateToBooking
                )
                .presentationDetents([.fraction(0.7), .large])
                .presentationDragIndicator(.visible)

            case .moreOptions(let postId):
                MoreOptionsSheetView(postId: postId)
                    .presentationDetents([.fraction(0.7)])
                    .presentationDragIndicator(.visible)
            }
        }
        .task {
            await viewModel.initialLoad()
        }
        .onChange(of: currentIndex) { _, newIndex in
            guard let index = newIndex, index < viewModel.posts.count else { return }
            
            viewModel.currentIndex = index
            let currentPost = viewModel.posts[index]
            
            Task {
                await viewModel.loadMore(currentPost: currentPost)
            }
        }
    }
}

