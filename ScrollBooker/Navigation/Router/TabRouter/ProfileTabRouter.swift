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
                        onNavigateToUserProfile: { },
                        onNavigateToUserSocial: {},
                        onNavigateToMyCalendar: {}
                    )
                } else {
                    ProgressView()
                }
            }
            .toolbar(router.profilePath.isEmpty ? .visible : .hidden, for: .tabBar)
            .withNavigation { route in
                switch route {
                    // MARK: - Settings Flow
                    case .mySettings:
                        SettingsScreen(
                            onNavigate: { r in router.push(r) },
                            onBack: { router.pop() }
                        )
                            .toolbar(.hidden, for: .navigationBar)
                        
                    case .display:
                        DisplayScreen(
                            onBack: { router.pop() }
                        )
                            .toolbar(.hidden, for: .navigationBar)
                        
                    case .reportProblem:
                        ReportProblemScreen(
                            viewModel: container.problemModule.makeProblemViewModel(userId: session.userInfo?.id ?? 0),
                            onBack: { router.pop() }
                        )
                            .toolbar(.hidden, for: .navigationBar)
                        
                    // MARK: - Edit Profile Flow
                    case .editProfile:
                        EditProfileScreen(
                            onNavigate: { r in router.push(r) },
                            onBack: { router.pop() }
                        )
                            .toolbar(.hidden, for: .navigationBar)
                        
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
                        EditUsernameScreen(
                            onBack: { router.pop() }
                        )
                            .toolbar(.hidden, for: .navigationBar)
                        
                    case .editBio:
                        EditBioScreen(
                            onBack: { router.pop() }
                        )
                            .toolbar(.hidden, for: .navigationBar)
                        
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
                        EditBirthdateScreen(
                            onBack: { router.pop() }
                        )
                            .toolbar(.hidden, for: .navigationBar)
                        
                    // MARK: - My Business Flow
                    case .myBusiness:
                        MyBusinessScreen (
                            onNavigate: { r in router.push(r) },
                            onBack: { router.pop() }
                        )
                           .toolbar(.hidden, for: .navigationBar)
                        
                    case .myBusinessDetails:
                        MyBusinessDetailsScreen()
                            .toolbar(.hidden, for: .navigationBar)
                        
                    case .myCalendar:
                        MyCalendarScreen(
                            onBack: { router.pop() }
                        )
                            .toolbar(.hidden, for: .navigationBar)
                    case .myProducts:
                        MyProductsScreen(
                            onBack: { router.pop() }
                        )
                            .toolbar(.hidden, for: .navigationBar)
                        
                    case .mySchedules:
                        MySchedulesScreen(
                            viewModel: container.scheduleModule.makeMySchedulesViewModel(session: session),
                            onBack: { router.pop() }
                        )
                            .toolbar(.hidden, for: .navigationBar)
                        
                    case .myServices:
                        MyServicesScreen(
                            viewModel: container.servieDomainModule.makeMyServicesViewModel(session: session),
                            onBack: { router.pop() }
                        )
                            .toolbar(.hidden, for: .navigationBar)
                        
                    case .myEmployees:
                        EmployeesFlowContainer(
                            container: container,
                            onBack: { router.pop() },
                            session: session,
                        )
                            .toolbar(.hidden, for: .navigationBar)
            
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
