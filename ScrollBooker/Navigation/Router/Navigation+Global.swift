//
//  GlobalRouters.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 12.07.2026.
//

import SwiftUI

enum DestinationResult<V: View> {
    case handled(V)
    case unhandled
}

struct GlobalNavigationModifier: ViewModifier {
    @Environment(AppContainer.self) private var container
    @Environment(SessionManager.self) private var session
    @Environment(Router.self) private var router

    let localDestination: (Route) -> (any View)?
    
    func body(content: Content) -> some View {
        content
            .navigationDestination(for: Route.self) { route in
                Group {
                    if let localView = localDestination(route) {
                        AnyView(localView)
                    } else {
                        globalScreen(for: route)
                    }
                }
                .toolbar(.hidden, for: .navigationBar)
            }
    }
    
    @ViewBuilder
    private func globalScreen(for route: Route) -> some View {
        switch route {
        case .appointmentDetails(let id):
            AppointmentDetailsScreen(
                viewModel: container.appointmentModule.makeAppointmentDetailsViewModel(
                    appointmentId: id,
                    session: session,
                    createReviewUseCase: container.reviewModule.createReviewUseCase,
                    updateReviewUseCase: container.reviewModule.updateReviewUseCase
                ),
                onBack: { router.pop() }
            )
            
        case .userProfile(let params):
            let userProfileViewModel = container.userProfileModule.makeUserProfileViewModel(
                userId: params.userId,
                username: params.username,
                getUserPostsUseCase: container.postModule.getUserPostsUseCase,
                getUserBookmarkedPostsUseCase: container.postModule.getUserBookmarkedPostsUseCase,
                getProductsByBusinessAndEmployeeUseCase: container.productModule.getProductsByBusinessAndEmployeeUseCase,
                getEmployeesByOwnerUseCase: container.employeesModule.getEmployeesByOwner,
            )

            UserProfileScreen(
                viewModel: userProfileViewModel,
                onNavigateToEditProfile: { router.push(.editProfile) },
                onNavigateToSettings: { router.push(.mySettings) },
                onNavigateToMyBusiness: { router.push(.myBusiness) },
                onNavigateToUserProfile: { router.push(.userProfile($0)) },
                onNavigateToUserSocial: { router.push(.userSocial($0)) },
                onNavigateToBooking: { router.push(.bookingServices($0)) },
                onBack: { router.pop() },
                makeOpeningHoursViewModel: { container.scheduleModule.makeOpeningHoursViewModel() },
                onNavigateToPost: { source, postId in
                    router.activeProfilePostDetailViewModel = container.postModule.makeProfilePostDetailViewModel(
                        profileController: userProfileViewModel.profileController,
                        source: source,
                        userId: params.userId,
                        startPostId: postId
                    )
                    router.pushWithoutAnimation(.profilePostDetail)
                }
            )

        case .profilePostDetail:
            if let viewModel = router.activeProfilePostDetailViewModel {
                ProfilePostDetailScreen(
                    viewModel: viewModel,
                    source: viewModel.source,
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
                    },
                    makeDeletePostVM: {
                        container.postModule.makeDeletePostViewModel()
                    },
                    onNavigateToUserProfile: { router.push(.userProfile($0)) },
                    onNavigateToBooking: { router.push(.bookingServices($0)) },
                    onBack: {
                        router.clearProfilePostDetailSession()
                        router.popWithoutAnimation()
                    }
                )
            } else {
                LoadingView()
            }

        case .userSocial(let params):
            SocialScreen(
                viewModel: container.followModule.makeSocialViewModel(userId: params.userId),
                onBack: { router.pop() },
                username: params.username,
                isBusinessOrEmployee: params.isBusinessOrEmployee,
                followersCount: params.followersCount,
                followingsCount: params.followingsCount,
                selectedTab: params.initialTab,
                onNavigateToUserProfile: { router.push(.userProfile($0)) },
            )
            
        case .bookingServices(let params):
            let viewModel: BookingViewModel = {
                if let existingVM = router.activeBookingViewModel,
                   existingVM.params.businessId == params.businessId {
                    return existingVM
                } else {
                    let newVM = container.bookingFlowModule.makeBookingFlowViewModel(
                        params: params,
                        getUserAvailableDaysUseCase: container.availabilityModule.getUserAvailableDaysUseCase,
                        getUserAvailableTimeslotsUseCase: container.availabilityModule.getUserAvailableTimeslotsUseCase,
                        createScrollBookerAppointmentUseCase: container.appointmentModule.createScrollBookerAppointmentUseCase
                    )
                    router.activeBookingViewModel = newVM
                    return newVM
                }
            }()
            
            BookingServicesScreen(
                viewModel: viewModel,
                onBack: {
                    router.clearBookingSession()
                    router.pop()
                },
                onNext: {
                    if viewModel.shouldSelectSpecialist {
                        router.push(.bookingSpecialists)
                    } else {
                        router.push(.bookingDateTime)
                    }
                }
            )
            
        case .bookingSpecialists:
            if let viewModel = router.activeBookingViewModel {
                BookingSpecialistsScreen(
                    viewModel: viewModel,
                    onBack: { router.pop() },
                    onNavigateToDateTime: { router.push(.bookingDateTime) }
                )
            } else {
                LoadingView()
            }
            
        case .bookingDateTime:
            if let viewModel = router.activeBookingViewModel {
                BookingDateTimeScreen(
                    viewModel: viewModel,
                    onBack: { router.pop() },
                    onNavigateToConfirmation: { router.push(.bookingConfirmation) }
                )
            } else {
                LoadingView()
            }
            
        case .bookingConfirmation:
            if let viewModel = router.activeBookingViewModel {
                BookingConfirmationScreen(
                    viewModel: viewModel,
                    onBack: { router.pop() },
                    onAppointmentCreated: {
                        Task {
                            let result = await viewModel.createAppointment()
                            
                            switch result {
                                case .success:
                                    router.popToRoot()
                                    router.clearBookingSession()
                                    withAnimation(.easeInOut) {
                                        router.selectedTab = .appointments
                                    }
                                    
                                case .failure:
                                    break
                                }
                        }
                    }
                )
            } else {
                LoadingView()
            }
            
            case .camera:
                let viewModel: CameraViewModel = {
                    if let existingVM = router.activeCameraViewModel {
                        return existingVM
                    } else {
                        let newVM = container.postModule.makeCameraViewModel(
                            cloudflareRepository: container.cloudflareModuke.repository
                        )
                        router.activeCameraViewModel = newVM
                        return newVM
                    }
                }()
                
                CameraScreen(
                    viewModel: viewModel,
                    onBack: {
                        router.clearCameraSession()
                        router.pop()
                    },
                    onNext: {
                        router.push(.cameraPreview)
                    }
                )
            
            case .cameraPreview:
                if let viewModel = router.activeCameraViewModel {
                    CameraPreviewScreen(
                        viewModel: viewModel,
                        onBack: { router.pop() },
                        onNext: { router.push(.createPost) }
                    )
                } else {
                    LoadingView()
                }
            
            case .createPost:
                if let viewModel = router.activeCameraViewModel {
                    CreatePostScreen(
                        viewModel: viewModel,
                        onBack: { router.pop()},
                        onNavigateToPostPreview: {}
                    )
                } else {
                    LoadingView()
                }
            
        default:
            Text("Route \(String(describing: route)) not implemented globally")
        }
    }
}


extension View {
    func withNavigation(localDestination: @escaping (Route) -> (any View)?) -> some View {
        self.modifier(GlobalNavigationModifier(localDestination: localDestination))
    }
    
    func withGlobalNavigation() -> some View {
        self.modifier(GlobalNavigationModifier(localDestination: { _ in nil }))
    }
}
