//
//  §TabRouter.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.08.2025.
//

import SwiftUI

struct ProfileTabRouter: View {
    @EnvironmentObject private var container: AppContainer
    @EnvironmentObject private var session: SessionManager
    var router: Router
    @State private var viewModel: MyProfileViewModel?
    
    var body: some View {
        @Bindable var bindableRouter = router
        
        NavigationStack(path: $bindableRouter.profilePath) {
            Group {
                if let stableViewModel = viewModel {
                    MyProfileScreen(
                        viewModel: stableViewModel,
                        onNavigateToEditProfile: { router.push(.editProfile) },
                        onNavigateToSettings: { router.push(.mySettings) },
                        onNavigateToMyBusiness: { router.push(.myBusiness) },
                        onNavigateToUserProfile: { userId, username in
                            router.push(.userProfile(userId: userId, username: username))
                        },
                        onNavigateToUserSocial: {},
                        onNavigateToMyCalendar: { router.push(.myCalendar) }
                    )
                } else {
                    ProgressView()
                }
            }
            .toolbar(router.profilePath.isEmpty ? .visible : .hidden, for: .tabBar)
            .withNavigation { route in
                switch route {
                    case .mySettings:
                        SettingsScreen(
                            onNavigate: { r in router.push(r) },
                            onBack: { router.pop() }
                        )
                        
                    case .display:
                        DisplayScreen(
                            onBack: { router.pop() }
                        )
                        
                    case .reportProblem:
                        ReportProblemScreen(
                            viewModel: container.problemModule.makeProblemViewModel(userId: session.userInfo?.id ?? 0),
                            onBack: { router.pop() }
                        )
                        
                    case .editProfile:
                        if let stableViewModel = viewModel {
                            EditProfileScreen(
                                viewModel: stableViewModel,
                                onNavigate: { r in router.push(r) },
                                onBack: { router.pop() }
                            )
                        } else {
                            LoadingView()
                                .onAppear {
                                    viewModel = container.userProfileModule.makeMyProfileViewModel(session: session)
                                }
                        }
                        
                    case .editFullName:
                        if let stableViewModel = viewModel {
                            EditNameScreen(
                                viewModel: stableViewModel,
                                onBack: { router.pop() }
                            )
                        } else {
                            LoadingView()
                                .onAppear {
                                    viewModel = container.userProfileModule.makeMyProfileViewModel(session: session)
                                }
                        }
                        
                    case .editUsername:
                        if let stableViewModel = viewModel {
                            EditUsernameScreen(
                                viewModel: stableViewModel,
                                onBack: { router.pop() }
                            )
                        } else {
                            LoadingView()
                                .onAppear {
                                    viewModel = container.userProfileModule.makeMyProfileViewModel(session: session)
                                }
                        }
                        
                    case .editBio:
                        if let stableViewModel = viewModel {
                            EditBioScreen(
                                viewModel: stableViewModel,
                                onBack: { router.pop() }
                            )
                        } else {
                            LoadingView()
                                .onAppear {
                                    viewModel = container.userProfileModule.makeMyProfileViewModel(session: session)
                                }
                        }
                        
                    case .editGender:
                        if let stableViewModel = viewModel {
                            EditGenderScreen(
                                viewModel: stableViewModel,
                                onBack: { router.pop() }
                            )
                        } else {
                            LoadingView()
                                .onAppear {
                                    viewModel = container.userProfileModule.makeMyProfileViewModel(session: session)
                                }
                        }
                        
                    case .editBirthdate:
                        if let stableViewModel = viewModel {
                            EditBirthdateScreen(
                                viewModel: stableViewModel,
                                onBack: { router.pop() }
                            )
                        } else {
                            LoadingView()
                                .onAppear {
                                    viewModel = container.userProfileModule.makeMyProfileViewModel(session: session)
                                }
                        }
                        
                    // MARK: - My Business Flow
                    case .myBusiness:
                        MyBusinessScreen (
                            onNavigate: { r in router.push(r) },
                            onBack: { router.pop() }
                        )
                        
                    case .myBusinessDetails:
                        MyBusinessDetailsScreen()
                    
                    case .mySchedules:
                        MySchedulesScreen(
                            viewModel: container.scheduleModule.makeMySchedulesViewModel(session: session),
                            onBack: { router.pop() }
                        )
                    
                    case .myProducts:
                        MyProductsScreen(
                            viewModel: container.productModule.makeMyProductsViewModel(session: session),
                            onBack: { router.pop() },
                            onNavigateAddProduct: {},
                            onNavigateEditProduct: { _, _ in }
                        )
                    
                    case .myServices:
                        MyServicesScreen(
                            viewModel: container.servieDomainModule.makeMyServicesViewModel(session: session),
                            onBack: { router.pop() }
                        )
                        
                    case .myCalendar:
                        MyCalendarScreen(onBack: { router.pop() })
                        
                    case .myEmployees:
                        EmployeesFlowContainer(
                            container: container,
                            onBack: { router.pop() },
                            session: session,
                        )
            
                    default:
                        nil
                    }
            }
        }
        .onAppear {
            if viewModel == nil {
                viewModel = container.userProfileModule.makeMyProfileViewModel(session: session)
            }
        }
    }
}
