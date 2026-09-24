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
    @Environment(ToastCenter.self) private var toastCenter

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
                    updateReviewUseCase: container.reviewModule.updateReviewUseCase,
                    deleteReviewUseCase: container.reviewModule.deleteReviewUseCase
                ),
                onNavigateToCamera: { router.push(.camera($0)) },
                onNavigateToBooking: { router.push(.bookingServices($0)) },
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
                getSchedulesByUserIdUseCase: container.scheduleModule.getSchedulesByUserIdUseCase,
                followUserUseCase: container.followModule.followUserUseCase,
                unfollowUserUseCase: container.followModule.unfollowUserUseCase,
            )

            UserProfileScreen(
                viewModel: userProfileViewModel,
                onBack: { router.pop() },
                onNavigateToEditProfile: { router.push(.editProfile) },
                onNavigateToSettings: { router.push(.mySettings) },
                onNavigateToMyBusiness: { router.push(.myBusiness) },
                onNavigateToMyCalendar: { router.push(.myCalendar) },
                onNavigateToPost: { source, postId in
                    router.activeProfilePostDetailViewModel = container.postModule.makeProfilePostDetailViewModel(
                        profileController: userProfileViewModel.profileController,
                        source: source,
                        userId: params.userId,
                        startPostId: postId
                    )
                    router.pushWithoutAnimation(.profilePostDetail)
                },
                onNavigateToUserProfile: { router.push(.userProfile($0)) },
                onNavigateToUserSocial: { router.push(.userSocial($0)) },
                onNavigateToBooking: { router.push(.bookingServices($0)) }
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
                    makeEditPostVM: { post in
                        container.postModule.makeEditPostViewModel(
                            post: post,
                            getSelectedDomainsByBusinessUseCase: container.servieDomainModule.getSelectedDomainsByBusinessUseCase,
                            getProductsByBusinessAndEmployeeUseCase: container.productModule.getProductsByBusinessAndEmployeeUseCase,
                            getPostLinkedProductsUseCase: container.productModule.getPostLinkedProductsUseCase
                        )
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
                reviewsViewModel: params.businessId.map {
                    container.reviewModule.makeReviewsViewModel(
                        businessId: $0,
                        employeeId: params.employeeId,
                        getVideoReviewsUseCase: container.postModule.getVideoReviewsUseCase
                    )
                },
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
                let hasDeepLinkSelection = params.appointmentId != nil || params.selectedProductId != nil

                if !hasDeepLinkSelection,
                   let existingVM = router.activeBookingViewModel,
                   existingVM.params.businessId == params.businessId {
                    return existingVM
                } else {
                    let newVM = container.bookingFlowModule.makeBookingFlowViewModel(
                        params: params,
                        getUserAvailableDaysUseCase: container.availabilityModule.getUserAvailableDaysUseCase,
                        getUserAvailableTimeslotsUseCase: container.availabilityModule.getUserAvailableTimeslotsUseCase,
                        createScrollBookerAppointmentUseCase: container.appointmentModule.createScrollBookerAppointmentUseCase,
                        getAppointmentByIdUseCase: container.appointmentModule.getAppointmentByIdUseCase
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
            
            case .camera(let params):
                CameraFlowContainer(
                    container: container,
                    session: session,
                    params: params,
                    onPostCreated: {
                        router.popToRoot()
                        router.selectedTab = .profile
                        Task { await router.myProfileViewModel?.refresh() }
                    },
                    onNavigateToEditProduct: { router.push(.editProduct(productId: $0)) },
                    onBack: { router.pop() }
                )

        // MARK: - My Account (reachable from any tab, e.g. UserProfileScreen when isOwnProfile)
        case .mySettings:
            SettingsScreen(
                onNavigate: { r in router.push(r) },
                onBack: { router.pop() }
            )

        case .display:
            DisplayScreen(onBack: { router.pop() })

        case .reportProblem:
            ReportProblemScreen(
                viewModel: container.problemModule.makeProblemViewModel(userId: session.userInfo?.id ?? 0),
                onBack: { router.pop() }
            )

        case .editProfile:
            EditProfileScreen(
                viewModel: resolveMyProfileViewModel(),
                onNavigate: { r in router.push(r) },
                onBack: { router.pop() }
            )

        case .editFullName:
            EditNameScreen(viewModel: resolveMyProfileViewModel(), onBack: { router.pop() })

        case .editUsername:
            EditUsernameScreen(viewModel: resolveMyProfileViewModel(), onBack: { router.pop() })

        case .editBio:
            EditBioScreen(viewModel: resolveMyProfileViewModel(), onBack: { router.pop() })

        case .editGender:
            EditGenderScreen(viewModel: resolveMyProfileViewModel(), onBack: { router.pop() })

        case .editBirthdate:
            EditBirthdateScreen(viewModel: resolveMyProfileViewModel(), onBack: { router.pop() })

        case .editAvatarCrop:
            EditAvatarCropScreen(viewModel: resolveMyProfileViewModel(), onBack: { router.pop() })

        case .myBusiness:
            MyBusinessScreen(
                onNavigate: { r in router.push(r) },
                onBack: { router.pop() }
            )

        case .myBusinessDetails:
            MyBusinessDetailsScreen(
                viewModel: container.businessModule.makeMyBusinessDetailsViewModel(session: session, toastCenter: toastCenter),
                onBack: { router.pop() }
            )

        case .unapprovedBusinesses:
            UnapprovedBusinessesScreen(
                viewModel: container.businessModule.makeUnapprovedBusinessesViewModel(),
                onBack: { router.pop() }
            )

        case .mySchedules:
            MySchedulesScreen(
                viewModel: container.scheduleModule.makeMySchedulesViewModel(session: session, toastCenter: toastCenter),
                onBack: { router.pop() }
            )

        case .myProducts:
            MyProductsScreen(
                viewModel: resolveMyProductsViewModel(),
                onBack: {
                    router.clearMyProductsSession()
                    router.pop()
                },
                onNavigateAddProduct: { router.push(.addProduct) },
                onNavigateEditProduct: { _, productId in router.push(.editProduct(productId: productId)) }
            )

        case .addProduct:
            AddProductScreen(
                viewModel: container.productModule.makeAddProductViewModel(
                    session: session,
                    getSelectedDomainsByBusinessUseCase: container.servieDomainModule.getSelectedDomainsByBusinessUseCase,
                    getEmployeesByOwnerUseCase: container.employeesModule.getEmployeesByOwner,
                    getFiltersByServiceUseCase: container.filterModule.getFiltersByServiceUseCase
                ),
                onBack: { router.pop() },
                onCreated: {
                    Task { await resolveMyProductsViewModel().refreshProducts() }
                    router.pop()
                }
            )

        case .editProduct(let productId):
            EditProductScreen(
                viewModel: container.productModule.makeEditProductViewModel(
                    productId: productId,
                    session: session,
                    getSelectedDomainsByBusinessUseCase: container.servieDomainModule.getSelectedDomainsByBusinessUseCase,
                    getEmployeesByOwnerUseCase: container.employeesModule.getEmployeesByOwner,
                    getFiltersByServiceUseCase: container.filterModule.getFiltersByServiceUseCase
                ),
                onBack: { router.pop() },
                onSaved: {
                    Task { await resolveMyProductsViewModel().refreshProducts() }
                    router.pop()
                },
                onVariantsChanged: {
                    Task { await resolveMyProductsViewModel().refreshProducts() }
                }
            )

        case .myServices:
            MyServicesScreen(
                viewModel: container.servieDomainModule.makeMyServicesViewModel(session: session, toastCenter: toastCenter),
                onBack: { router.pop() }
            )

        case .myCalendar:
            if let userInfo = session.userInfo, let businessId = userInfo.businessId {
                let myCalendarViewModel = container.myCalendarModule.makeMyCalendarViewModel(
                    userId: userInfo.id,
                    businessId: businessId,
                    businessOwnerId: userInfo.businessOwnerId,
                    hasEmployees: userInfo.hasEmployees,
                    ownAvatar: userInfo.avatar,
                    ownFullName: userInfo.fullName,
                    getUserAvailableDaysUseCase: container.availabilityModule.getUserAvailableDaysUseCase,
                    getUserCalendarEventsUseCase: container.availabilityModule.getUserCalendarEventsUseCase,
                    getSchedulesByUserIdUseCase: container.scheduleModule.getSchedulesByUserIdUseCase,
                    getUserCalendarSettingsUseCase: container.userCalendarSettingsModule.getUserCalendarSettingsUseCase,
                    updateSlotDurationUseCase: container.userCalendarSettingsModule.updateSlotDurationUseCase,
                    updateAppointmentGapUseCase: container.userCalendarSettingsModule.updateAppointmentGapUseCase,
                    createBlockAppointmentsUseCase: container.appointmentModule.createBlockAppointmentsUseCase,
                    getEmployeesByOwnerUseCase: container.employeesModule.getEmployeesByOwner,
                    getEmployeesAvailabilityForDayUseCase: container.availabilityModule.getEmployeesAvailabilityForDayUseCase,
                    toastCenter: toastCenter
                )

                MyCalendarScreen(
                    viewModel: myCalendarViewModel,
                    onBack: { router.pop() },
                    makeAddOwnClientViewModel: { initialSlot in
                        container.addOwnClientModule.makeAddOwnClientViewModel(
                            businessId: myCalendarViewModel.resolvedBusinessId,
                            employeeId: myCalendarViewModel.effectiveEmployeeId,
                            targetUserId: myCalendarViewModel.targetUserId,
                            initialDay: initialSlot?.startDate,
                            initialSlot: initialSlot?.toSlot(),
                            getProductsByBusinessAndEmployeeUseCase: container.productModule.getProductsByBusinessAndEmployeeUseCase,
                            getUserAvailableDaysUseCase: container.availabilityModule.getUserAvailableDaysUseCase,
                            getUserAvailableTimeslotsUseCase: container.availabilityModule.getUserAvailableTimeslotsUseCase,
                            getBusinessClientsUseCase: container.businessClientModule.getBusinessClientsUseCase,
                            createBusinessClientUseCase: container.businessClientModule.createBusinessClientUseCase,
                            createOwnClientAppointmentUseCase: container.appointmentModule.createOwnClientAppointmentUseCase,
                            toastCenter: toastCenter
                        )
                    }
                )
            }

        case .myDashboard:
            MyDashboardScreen(
                viewModel: container.dashboardModule.makeDashboardViewModel(),
                onBack: { router.pop() }
            )

        case .myEmployees:
            EmployeesFlowContainer(
                container: container,
                onBack: { router.pop() },
                session: session
            )

        default:
            Text("Route \(String(describing: route)) not implemented globally")
        }
    }

    private func resolveMyProfileViewModel() -> MyProfileViewModel {
        if let existing = router.myProfileViewModel {
            return existing
        }

        let newViewModel = container.userProfileModule.makeMyProfileViewModel(
            session: session,
            getUserPostsUseCase: container.postModule.getUserPostsUseCase,
            getUserBookmarkedPostsUseCase: container.postModule.getUserBookmarkedPostsUseCase,
            getProductsByBusinessAndEmployeeUseCase: container.productModule.getProductsByBusinessAndEmployeeUseCase,
            getEmployeesByOwnerUseCase: container.employeesModule.getEmployeesByOwner,
            getSchedulesByUserIdUseCase: container.scheduleModule.getSchedulesByUserIdUseCase
        )
        router.myProfileViewModel = newViewModel
        return newViewModel
    }

    private func resolveMyProductsViewModel() -> MyProductsViewModel {
        if let existing = router.myProductsViewModel {
            return existing
        }

        let newViewModel = container.productModule.makeMyProductsViewModel(session: session)
        router.myProductsViewModel = newViewModel
        return newViewModel
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
