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
    let makeLinkedProductsVM: (Post) -> LinkedProductsViewModel
    let makeReviewsVM: (Post) -> ReviewsViewModel
    let makeStatisticsVM: (Int) -> PostStatisticsViewModel
    let makeDeletePostVM: () -> DeletePostViewModel
    var onNavigateToUserProfile: (ProfileNavigationParams) -> Void
    let onNavigateToBooking: (BookingNavigationParams) -> Void

    @State private var currentIndex: Int? = 0
    @State private var activeSheet: FeedSheetType? = nil
    @State private var pendingSheetAction: (() -> Void)?
    @State private var statisticsPostId: Int?
    
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
                        title: String(localized: "title_posts"),
                        message: "Nu există postări",
                        systemImage: "video.slash"
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
            onOpenReviewsSheet: { activeSheet = .reviews(post: $0) },
            onOpenLinkedProductsSheet: { activeSheet = .linkedProducts(post: $0) },
            onOpenCommentsSheet: { activeSheet = .comments(postId: $0) },
            onOpenMoreOptions: { activeSheet = .moreOptions(postId: $0) },
            onLike: { id in Task { await viewModel.toggleLikePost(id: id) } },
            onBookmark: { id in Task { await viewModel.toggleBookmarkPost(id: id) } }
        ))
        .sheet(item: $activeSheet, onDismiss: {
            pendingSheetAction?()
            pendingSheetAction = nil
        }) { sheetType in
            switch sheetType {
            case .comments(let postId):
                CommentsSheetView(
                    viewModel: commentsCache.viewModel(for: postId, make: makeCommentsVM),
                    onNavigateToUserProfile: onNavigateToUserProfile
                )
                .presentationDetents([.fraction(0.7), .large])
                .presentationDragIndicator(.visible)

            case .reviews(let post):
                ReviewsSheetView(
                    viewModel: reviewsCache.viewModel(for: post.id, make: { _ in makeReviewsVM(post) })
                )
                .presentationDetents([.fraction(0.7), .large])
                    .presentationDragIndicator(.visible)

            case .linkedProducts(let post):
                LinkedProductsSheetView(
                    viewModel: linkedProductsCache.viewModel(for: post.id, make: { _ in makeLinkedProductsVM(post) }),
                    post: post,
                    bookingSource: .followingFeed,
                    onNavigateToUserProfile: onNavigateToUserProfile,
                    onNavigateToBooking: onNavigateToBooking
                )
                .presentationDetents([.fraction(0.7), .large])
                .presentationDragIndicator(.visible)

            case .moreOptions(let postId):
                MoreOptionsSheetView(
                    postId: postId,
                    onOpenStatistics: { id in pendingSheetAction = { statisticsPostId = id } },
                    onOpenDeleteConfirm: { id in pendingSheetAction = { activeSheet = .deletePost(postId: id) } }
                )

            case .deletePost(let postId):
                DeletePostSheetView(
                    postId: postId,
                    viewModel: makeDeletePostVM(),
                    onDeleted: { _ in Task { await viewModel.refreshPosts() } }
                )
            }
        }
        .fullScreenCover(isPresented: Binding(
            get: { statisticsPostId != nil },
            set: { if !$0 { statisticsPostId = nil } }
        )) {
            if let statisticsPostId {
                PostStatisticsScreen(
                    viewModel: makeStatisticsVM(statisticsPostId),
                    onBack: { self.statisticsPostId = nil }
                )
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

