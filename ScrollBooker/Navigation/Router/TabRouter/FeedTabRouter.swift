//
//  FeedTabRouter.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct FeedTabRouter: View {
    @Environment(AppContainer.self) private var container
    var router: Router
    
    @State private var feedViewModel: FeedViewModel?
    @State private var isDrawerOpen = false
    @State private var dragOffset: CGFloat = 0

    var body: some View {
        @Bindable var bindableRouter = router

        NavigationStack(path: $bindableRouter.feedPath) {
            GeometryReader { geometry in
                let drawerWidth = geometry.size.width * 0.8

                ZStack(alignment: .leading) {
                    Group {
                        if let viewModel = feedViewModel {
                            FeedScreen(
                                viewModel: viewModel,
                                onNavigateToFeedSearch: { router.push(.feedSearch) },
                                onNavigateToUserProfile: { router.push(.userProfile($0)) },
                                onNavigateToBooking: { router.push(.bookingServices($0)) },
                                onOpenDrawer: {
                                    withAnimation(.easeInOut(duration: 0.25)) { isDrawerOpen = true }
                                },
                                makeCommentsVM: { container.commentModule.makeCommentsViewModel(postId: $0) },
                                makeLinkedProductsVM: { post in
                                    container.productModule.makeLinkedProductsViewModel(
                                        postId: post.id,
                                        postUserId: post.user.id,
                                        isVideoReview: post.isVideoReview,
                                        getAppointmentByUserAndPostUseCase: container.appointmentModule.getAppointmentByUserAndPostUseCase
                                    )
                                },
                                makeReviewsVM: { post in
                                    let isEmployee = post.user.id != post.businessOwner.id
                                    return container.reviewModule.makeReviewsViewModel(
                                        businessId: post.businessId ?? post.businessOwner.id,
                                        employeeId: isEmployee ? post.user.id : nil,
                                        getVideoReviewsUseCase: container.postModule.getVideoReviewsUseCase
                                    )
                                },
                                makeStatisticsVM: { postId in
                                    container.postModule.makePostStatisticsViewModel(postId: postId)
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

                    if isDrawerOpen {
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.25)) { isDrawerOpen = false }
                            }
                            .transition(.opacity)
                    }

                    FeedDrawerView(
                        serviceDomainsState: feedViewModel?.exploreViewModel.serviceDomainsState ?? .idle,
                        selectedServiceIds: feedViewModel?.exploreViewModel.selectedServiceIds ?? [],
                        onlyVideoReviews: feedViewModel?.exploreViewModel.onlyVideoReviews ?? false,
                        isOpen: isDrawerOpen,
                        onApplyFilters: { serviceIds, onlyVideoReviews in
                            Task {
                                await feedViewModel?.exploreViewModel.applyFilters(
                                    serviceIds: serviceIds,
                                    onlyVideoReviews: onlyVideoReviews
                                )
                            }
                        },
                        onRequestClose: {
                            withAnimation(.easeInOut(duration: 0.25)) { isDrawerOpen = false }
                        }
                    )
                        .frame(width: drawerWidth)
                        .frame(maxHeight: .infinity)
                        .offset(x: isDrawerOpen ? dragOffset : -drawerWidth)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    dragOffset = max(-drawerWidth, min(0, value.translation.width))
                                }
                                .onEnded { value in
                                    let closeThreshold = drawerWidth * 0.3
                                    if value.translation.width < -closeThreshold {
                                        withAnimation(.easeInOut(duration: 0.25)) {
                                            isDrawerOpen = false
                                        }
                                    }
                                    withAnimation(.easeInOut(duration: 0.25)) {
                                        dragOffset = 0
                                    }
                                }
                        )
                }
            }
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



