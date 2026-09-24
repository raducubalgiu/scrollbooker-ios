//
//  ReviewVideoDetailScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.09.2026.
//

import SwiftUI

struct ReviewVideoDetailScreen: View {
    @Environment(Router.self) private var router

    var viewModel: ReviewVideoDetailViewModel

    let makeCommentsVM: (Int) -> CommentsViewModel
    let makeLinkedProductsVM: (Post) -> LinkedProductsViewModel
    let makeReviewsVM: (Post) -> ReviewsViewModel
    let makeStatisticsVM: (Int) -> PostStatisticsViewModel
    let makeDeletePostVM: () -> DeletePostViewModel
    let makeEditPostVM: (Post) -> EditPostViewModel
    var onNavigateToUserProfile: (ProfileNavigationParams) -> Void
    let onNavigateToBooking: (BookingNavigationParams) -> Void
    let onNavigateToReviewVideoDetail: (ReviewsViewModel, Int) -> Void
    var onBack: () -> Void

    @State private var currentIndex: Int?
    @State private var activeSheet: FeedSheetType? = nil
    @State private var pendingSheetAction: (() -> Void)?
    @State private var statisticsPostId: Int?
    @State private var editPostId: Int?

    @State private var commentsCache = ViewModelCache<Int, CommentsViewModel>()
    @State private var linkedProductsCache = ViewModelCache<Int, LinkedProductsViewModel>()
    @State private var reviewsCache = ViewModelCache<Int, ReviewsViewModel>()

    init(
        viewModel: ReviewVideoDetailViewModel,
        makeCommentsVM: @escaping (Int) -> CommentsViewModel,
        makeLinkedProductsVM: @escaping (Post) -> LinkedProductsViewModel,
        makeReviewsVM: @escaping (Post) -> ReviewsViewModel,
        makeStatisticsVM: @escaping (Int) -> PostStatisticsViewModel,
        makeDeletePostVM: @escaping () -> DeletePostViewModel,
        makeEditPostVM: @escaping (Post) -> EditPostViewModel,
        onNavigateToUserProfile: @escaping (ProfileNavigationParams) -> Void,
        onNavigateToBooking: @escaping (BookingNavigationParams) -> Void,
        onNavigateToReviewVideoDetail: @escaping (ReviewsViewModel, Int) -> Void,
        onBack: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.makeCommentsVM = makeCommentsVM
        self.makeLinkedProductsVM = makeLinkedProductsVM
        self.makeReviewsVM = makeReviewsVM
        self.makeStatisticsVM = makeStatisticsVM
        self.makeDeletePostVM = makeDeletePostVM
        self.makeEditPostVM = makeEditPostVM
        self.onNavigateToUserProfile = onNavigateToUserProfile
        self.onNavigateToBooking = onNavigateToBooking
        self.onNavigateToReviewVideoDetail = onNavigateToReviewVideoDetail
        self.onBack = onBack
        _currentIndex = State(initialValue: viewModel.currentIndex)
    }

    private var currentPost: Post? {
        guard let index = currentIndex, viewModel.posts.indices.contains(index) else { return nil }
        return viewModel.posts[index]
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.black.ignoresSafeArea()

            PostsSuccessView(viewModel: viewModel, currentIndex: $currentIndex, showBookButton: false)
                .ignoresSafeArea(edges: .top)

            header
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            bookNowButton
        }
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
                        onDeleted: { _ in onBack() }
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
        .onChange(of: currentIndex) { _, newIndex in
            guard let index = newIndex, index < viewModel.posts.count else { return }

            viewModel.currentIndex = index
            let currentPost = viewModel.posts[index]

            Task {
                await viewModel.loadMore(currentPost: currentPost)
            }
        }
        .onDisappear {
            viewModel.pauseAll()
            router.popReviewVideoDetail(viewModel)
        }
    }

    private var header: some View {
        ZStack {
            HStack {
                Button(action: onBack) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 36, height: 36)
                        .background(Color.black.opacity(0.35))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)

                Spacer()
            }
        }
        .padding(.horizontal, .base)
        .padding(.top, .s)
    }

    private var bookNowButton: some View {
        PostMainActionView(isVideoReview: currentPost?.isVideoReview ?? false) {
            guard let currentPost else { return }
            activeSheet = .linkedProducts(post: currentPost)
        }
        .padding(.horizontal, .base)
        .padding(.vertical, .s)
        .background(Color.black)
    }
}
