//
//  ExploreTab.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 23.07.2026.
//

import SwiftUI

struct ExploreTab: View {
    var viewModel: ExploreTabViewModel
    
    let makeCommentsVM: (Int) -> CommentsViewModel
    let makeLinkedProductsVM: (Post) -> LinkedProductsViewModel
    let makeReviewsVM: (Post) -> ReviewsViewModel
    let makeStatisticsVM: (Int) -> PostStatisticsViewModel
    let makeDeletePostVM: () -> DeletePostViewModel
    let makeEditPostVM: (Post) -> EditPostViewModel
    var onNavigateToUserProfile: (ProfileNavigationParams) -> Void
    let onNavigateToBooking: (BookingNavigationParams) -> Void
    let onNavigateToReviewVideoDetail: (ReviewsViewModel, Int) -> Void

    @State private var currentIndex: Int? = 0
    @State private var activeSheet: FeedSheetType? = nil
    @State private var pendingSheetAction: (() -> Void)?
    @State private var statisticsPostId: Int?
    @State private var editPostId: Int?

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
                        message: String(localized: "message_empty_posts"),
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
            onOpenReviewsSheet: { post in activeSheet = .reviews(post: post) },
            onOpenLinkedProductsSheet: { post in activeSheet = .linkedProducts(post: post) },
            onOpenCommentsSheet: { postId in activeSheet = .comments(postId: postId) },
            onOpenMoreOptions: { postId in activeSheet = .moreOptions(postId: postId) },
            onLike: { id in Task { await viewModel.toggleLikePost(id: id) } },
            onBookmark: { id in Task { await viewModel.toggleBookmarkPost(id: id) } },
            onFollow: { id in Task { await viewModel.toggleFollowPost(id: id) } },
            onShare: { post, _ in
                ShareHelper.sharePost(post: post) { resolvedChannel in
                    Task {
                        await viewModel.sharePost(id: post.id, channel: resolvedChannel)
                    }
                }
            }
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
                    .presentationDetents([.fraction(0.7), .fraction(0.999)])
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(25)

                case .reviews(let post):
                    let reviewsVM = reviewsCache.viewModel(for: post.id, make: { _ in makeReviewsVM(post) })
                    ReviewsSheetView(
                        viewModel: reviewsVM,
                        onNavigateToVideoReview: { videoPost in
                            pendingSheetAction = { onNavigateToReviewVideoDetail(reviewsVM, videoPost.id) }
                        }
                    )
                    .presentationDetents([.fraction(0.7), .fraction(0.999)])
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(25)

                case .linkedProducts(let post):
                    LinkedProductsSheetView(
                        viewModel: linkedProductsCache.viewModel(for: post.id, make: { _ in makeLinkedProductsVM(post) }),
                        post: post,
                        bookingSource: .exploreFeed,
                        onNavigateToUserProfile: onNavigateToUserProfile,
                        onNavigateToBooking: onNavigateToBooking
                    )
                    .presentationDetents([.fraction(0.7), .fraction(0.999)])
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(25)

                case .moreOptions(let postId):
                    MoreOptionsSheetView(
                        postId: postId,
                        onOpenStatistics: { id in pendingSheetAction = { statisticsPostId = id } },
                        onNavigateToEditPost: { id in pendingSheetAction = { editPostId = id } },
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
        .fullScreenCover(isPresented: Binding(
            get: { editPostId != nil },
            set: { if !$0 { editPostId = nil } }
        )) {
            if let editPostId, let post = viewModel.posts.first(where: { $0.id == editPostId }) {
                EditPostScreen(
                    viewModel: makeEditPostVM(post),
                    onBack: { self.editPostId = nil }
                )
            }
        }
        .task {
            async let postsTask: () = viewModel.initialLoad()
            async let domainsTask: () = viewModel.loadServiceDomains()
            _ = await (postsTask, domainsTask)
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
