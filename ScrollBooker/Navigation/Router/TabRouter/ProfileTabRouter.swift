//
//  §TabRouter.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.08.2025.
//

import SwiftUI

struct ProfileTabRouter: View {
    @Environment(AppContainer.self) private var container
    @Environment(SessionManager.self) private var session
    var router: Router

    var body: some View {
        @Bindable var bindableRouter = router

        NavigationStack(path: $bindableRouter.profilePath) {
            Group {
                if let stableViewModel = router.myProfileViewModel {
                    MyProfileScreen(
                        viewModel: stableViewModel,
                        onNavigateToEditProfile: { router.push(.editProfile) },
                        onNavigateToSettings: { router.push(.mySettings) },
                        onNavigateToMyBusiness: { router.push(.myBusiness) },
                        onNavigateToMyCalendar: { router.push(.myCalendar) },
                        onNavigateToCamera: { router.push(.camera(CameraParams())) },
                        onNavigateToUserProfile: { router.push(.userProfile($0)) },
                        onNavigateToUserSocial: { router.push(.userSocial($0)) },
                        onNavigateToPost: { source, postId in
                            guard let userId = session.userInfo?.id else { return }

                            router.activeProfilePostDetailViewModel = container.postModule.makeProfilePostDetailViewModel(
                                profileController: stableViewModel.profileController,
                                source: source,
                                userId: userId,
                                startPostId: postId
                            )
                            router.pushWithoutAnimation(.profilePostDetail)
                        }
                    )
                    .safeAreaInset(edge: .bottom, spacing: 0) {
                        CustomTabBar(backgroundColor: .backgroundSB)
                    }
                } else {
                    ProgressView()
                }
            }
            .withGlobalNavigation()
        }
        .onChange(of: router.selectedTab, initial: true) { _, newTab in
            if newTab == .profile && router.myProfileViewModel == nil {
                setupViewModel()
            }
        }
    }

    private func setupViewModel() {
        router.myProfileViewModel = container.userProfileModule.makeMyProfileViewModel(
            session: session,
            getUserPostsUseCase: container.postModule.getUserPostsUseCase,
            getUserBookmarkedPostsUseCase: container.postModule.getUserBookmarkedPostsUseCase,
            getProductsByBusinessAndEmployeeUseCase: container.productModule.getProductsByBusinessAndEmployeeUseCase,
            getEmployeesByOwnerUseCase: container.employeesModule.getEmployeesByOwner,
            getSchedulesByUserIdUseCase: container.scheduleModule.getSchedulesByUserIdUseCase
        )
    }
}
