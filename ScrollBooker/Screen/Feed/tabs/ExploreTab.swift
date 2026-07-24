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
    let makeLinkedProductsVM: (Int) -> LinkedProductsViewModel
    var onNavigateToUserProfile: (ProfileNavigationParams) -> Void
    let onNavigateToBooking: (BookingNavigationParams) -> Void
    
    @State private var currentIndex: Int? = 0
    @State private var activeSheet: FeedSheetType? = nil
    
    var body: some View {
        GeometryReader { globalGeo in
            let videoHeight = globalGeo.size.height
            let videoWidth = globalGeo.size.width

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
                    
                case .success(let posts):
                    ScrollView(.vertical) {
                        LazyVStack(spacing: 0) {
                            ForEach(Array(posts.enumerated()), id: \.element.id) { index, post in
                                ZStack {
                                    // Deocamdată placeholder, ne ocupăm de AVPlayer ulterior
                                    Color.black

                                    PostOverlayView(
                                        post: post,
                                        onNavigateToUserProfile: onNavigateToUserProfile,
                                        onOpenReviewsSheet: { activeSheet = .reviews(userId: $0) },
                                        onOpenLinkedProductsSheet: { activeSheet = .linkedProducts(postId: $0) },
                                        onOpenCommentsSheet: { activeSheet = .comments(postId: $0) },
                                    )
                                }
                                .frame(width: videoWidth, height: videoHeight)
                                .id(index)
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
                    .scrollIndicators(.never)
                    .scrollPosition(id: $currentIndex)
                    .refreshable {
                        await viewModel.refreshPosts()
                    }
                }
        }
        .ignoresSafeArea(edges: .top)
        .background(Color.black)
        .sheet(item: $activeSheet) { sheetType in
            switch sheetType {
                case .comments(let postId):
                    CommentsSheetView(
                        viewModel: makeCommentsVM(postId),
                        onNavigateToUserProfile: onNavigateToUserProfile
                    )
                        .presentationDetents([.fraction(0.7)])
                        .presentationDragIndicator(.visible)
                    
                case .reviews(let userId):
                    ReviewsSheetView(userId: userId)
                        .presentationDetents([.fraction(0.7)])
                        .presentationDragIndicator(.visible)
                    
                case .linkedProducts(let postId):
                    LinkedProductsSheetView(
                        viewModel: makeLinkedProductsVM(postId),
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
            let currentPost = viewModel.posts[index]
            
            Task {
                await viewModel.loadMore(currentPost: currentPost)
            }
        }
    }
}
