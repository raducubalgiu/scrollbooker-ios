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
    let makeLinkedProductsVM: (Int) -> LinkedProductsViewModel
    let makeReviewsVM: (Int) -> ReviewsViewModel
    var onNavigateToUserProfile: (ProfileNavigationParams) -> Void
    let onNavigateToBooking: (BookingNavigationParams) -> Void
    var onBack: () -> Void

    @State private var currentIndex: Int?
    @State private var activeSheet: FeedSheetType? = nil

    @State private var commentsCache = ViewModelCache<Int, CommentsViewModel>()
    @State private var linkedProductsCache = ViewModelCache<Int, LinkedProductsViewModel>()
    @State private var reviewsCache = ViewModelCache<Int, ReviewsViewModel>()

    init(
        viewModel: ProfilePostDetailViewModel,
        source: ProfilePostSource,
        makeCommentsVM: @escaping (Int) -> CommentsViewModel,
        makeLinkedProductsVM: @escaping (Int) -> LinkedProductsViewModel,
        makeReviewsVM: @escaping (Int) -> ReviewsViewModel,
        onNavigateToUserProfile: @escaping (ProfileNavigationParams) -> Void,
        onNavigateToBooking: @escaping (BookingNavigationParams) -> Void,
        onBack: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.source = source
        self.makeCommentsVM = makeCommentsVM
        self.makeLinkedProductsVM = makeLinkedProductsVM
        self.makeReviewsVM = makeReviewsVM
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
            onOpenReviewsSheet: { userId in activeSheet = .reviews(userId: userId) },
            onOpenLinkedProductsSheet: { postId in activeSheet = .linkedProducts(postId: postId) },
            onOpenCommentsSheet: { postId in activeSheet = .comments(postId: postId) },
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
                    .presentationDetents([.fraction(0.7), .fraction(0.999)])
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(25)

                case .reviews(let userId):
                    ReviewsSheetView(
                        viewModel: reviewsCache.viewModel(for: userId, make: makeReviewsVM)
                    )
                    .presentationDetents([.fraction(0.7), .fraction(0.999)])
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(25)

                case .linkedProducts(let postId):
                    LinkedProductsSheetView(
                        viewModel: linkedProductsCache.viewModel(for: postId, make: makeLinkedProductsVM),
                        onNavigateToBooking: onNavigateToBooking
                    )
                    .presentationDetents([.fraction(0.7), .fraction(0.999)])
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(25)

                case .moreOptions(let postId):
                    MoreOptionsSheetView(postId: postId)
                        .presentationDetents([.fraction(0.7)])
                        .presentationDragIndicator(.visible)
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
        PostMainActionView {
            guard let currentPost else { return }
            activeSheet = .linkedProducts(postId: currentPost.id)
        }
        .padding(.horizontal, .base)
        .padding(.vertical, .s)
        .background(Color.black)
    }
}
