//
//  FeedTabRouter.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct FeedTabRouter: View {
    @EnvironmentObject private var container: AppContainer
    var router: Router
    
    @State private var feedViewModel: FeedViewModel?

    var body: some View {
        @Bindable var bindableRouter = router
        
        NavigationStack(path: $bindableRouter.feedPath) {
            Group {
                if let viewModel = feedViewModel {
                    FeedScreen(
                        viewModel: viewModel,
                        onNavigateToFeedSearch: { router.push(.feedSearch) },
                        onNavigateToUserProfile: { router.push(.userProfile($0)) },
                        onNavigateToBooking: { router.push(.bookingServices($0)) },
                        makeCommentsVM: { container.commentModule.makeCommentsViewModel(postId: $0) },
                        makeLinkedProductsVM: { container.productModule.makeLinkedProductsViewModel(postId: $0) },
                        makeReviewsVM: {
                            container.reviewModule.makeReviewsViewModel(
                                userId: $0,
                                getVideoReviewsUseCase: container.postModule.getVideoReviewsUseCase
                            )
                        }
                    )
                    .safeAreaInset(edge: .bottom, spacing: 0) {
                        CustomTabBar(backgroundColor: Color.black)
                    }
                } else {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .withNavigation { route in
                switch route {
                case .feedSearch:
                    FeedSearchScreen(
                        viewModel: container.searchModule.makeFeedSearchViewModel(),
                        onBack: { router.pop() },
                        onNavigateToUserProfile: { router.push(.userProfile($0)) }
                    )
                default:
                    nil
                }
            }
            .onAppear {
                if feedViewModel == nil {
                    feedViewModel = container.postModule.makeFeedViewModel()
                }
                
                switch feedViewModel?.selectedTab {
                    case .explore:
                        feedViewModel?.exploreViewModel.playCurrent()
                    case .following:
                        feedViewModel?.followingViewModel.playCurrent()
                    case .none:
                    break
                }
            }
            .onDisappear {
                feedViewModel?.exploreViewModel.pauseAll()
                feedViewModel?.followingViewModel.pauseAll()
            }
        }
    }
}



