//
//  ProfilePostDetailScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.09.2026.
//

import SwiftUI

/// Shared by both "my own profile" and "another user's profile" — mirrors Android's
/// BaseProfilePostDetailScreen: same pager/sheet machinery as ExploreTab/FollowingTab, but pushed
/// as its own full-screen destination (own header with a title reflecting which grid it was opened
/// from, own close button, own currentIndex seeded at the tapped post) with the per-post inline
/// "Rezervă acum" button replaced by one persistent bar pinned under the pager.
struct ProfilePostDetailScreen: View {
    var viewModel: ProfilePostDetailViewModel
    let source: ProfilePostSource

    let makeCommentsVM: (Int) -> CommentsViewModel
    let makeLinkedProductsVM: (Post) -> LinkedProductsViewModel
    let makeReviewsVM: (Post) -> ReviewsViewModel
    let makeStatisticsVM: (Int) -> PostStatisticsViewModel
    let makeDeletePostVM: () -> DeletePostViewModel
    var onNavigateToUserProfile: (ProfileNavigationParams) -> Void
    let onNavigateToBooking: (BookingNavigationParams) -> Void
    var onBack: () -> Void

    @State private var currentIndex: Int?
    @State private var activeSheet: FeedSheetType? = nil
    @State private var pendingSheetAction: (() -> Void)?
    @State private var statisticsPostId: Int?

    @State private var commentsCache = ViewModelCache<Int, CommentsViewModel>()
    @State private var linkedProductsCache = ViewModelCache<Int, LinkedProductsViewModel>()
    @State private var reviewsCache = ViewModelCache<Int, ReviewsViewModel>()

    init(
        viewModel: ProfilePostDetailViewModel,
        source: ProfilePostSource,
        makeCommentsVM: @escaping (Int) -> CommentsViewModel,
        makeLinkedProductsVM: @escaping (Post) -> LinkedProductsViewModel,
        makeReviewsVM: @escaping (Post) -> ReviewsViewModel,
        makeStatisticsVM: @escaping (Int) -> PostStatisticsViewModel,
        makeDeletePostVM: @escaping () -> DeletePostViewModel,
        onNavigateToUserProfile: @escaping (ProfileNavigationParams) -> Void,
        onNavigateToBooking: @escaping (BookingNavigationParams) -> Void,
        onBack: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.source = source
        self.makeCommentsVM = makeCommentsVM
        self.makeLinkedProductsVM = makeLinkedProductsVM
        self.makeReviewsVM = makeReviewsVM
        self.makeStatisticsVM = makeStatisticsVM
        self.makeDeletePostVM = makeDeletePostVM
        self.onNavigateToUserProfile = onNavigateToUserProfile
        self.onNavigateToBooking = onNavigateToBooking
        self.onBack = onBack
        _currentIndex = State(initialValue: viewModel.currentIndex)
    }

    private var title: String {
        switch source {
        case .posts: String(localized: "title_posts")
        case .bookmarks: String(localized: "title_bookmarks")
        }
    }

    private var currentPost: Post? {
        guard let index = currentIndex, viewModel.posts.indices.contains(index) else { return nil }
        return viewModel.posts[index]
    }

    private var bookingSource: BookingSourceEnum {
        switch source {
        case .posts: .profileGridPostDetail
        case .bookmarks: .profileBookmarksPostDetail
        }
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.black.ignoresSafeArea()

            PostsSuccessView(viewModel: viewModel, currentIndex: $currentIndex, showBookButton: false)
                .ignoresSafeArea(edges: .top)

            header
        }
        // .ignoresSafeArea(.all) (Explore/Following's own default) would also ignore the bottom
        // region this safeAreaInset reserves, so containerRelativeFrame would size against the
        // full screen and the video would render straight through/under the bar. Restricting to
        // the top edge extends the video under the status bar only, leaving the bottom safe area
        // (now including this bar's height) intact for containerRelativeFrame to size against —
        // giving exactly totalHeight - bar height, with the bar itself opaque and non-overlapping.
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
                    .presentationDetents([.fraction(0.7), .fraction(0.999)])
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(25)

                case .reviews(let post):
                    ReviewsSheetView(
                        viewModel: reviewsCache.viewModel(for: post.id, make: { _ in makeReviewsVM(post) })
                    )
                    .presentationDetents([.fraction(0.7), .fraction(0.999)])
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(25)

                case .linkedProducts(let post):
                    LinkedProductsSheetView(
                        viewModel: linkedProductsCache.viewModel(for: post.id, make: { _ in makeLinkedProductsVM(post) }),
                        post: post,
                        bookingSource: bookingSource,
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
        }
    }

    private var header: some View {
        ZStack {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .lineLimit(1)
                .padding(.horizontal, 56)

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
