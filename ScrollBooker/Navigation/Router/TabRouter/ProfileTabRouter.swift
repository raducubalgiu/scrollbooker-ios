//
//  §TabRouter.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.08.2025.
//

import SwiftUI

struct HidesBottomBarWhenPushed: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = .clear
        DispatchQueue.main.async {
            vc.hidesBottomBarWhenPushed = true
        }
        return vc
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

extension View {
    func hidesBottomBarWhenPushed() -> some View {
        self.background(HidesBottomBarWhenPushed().frame(width: 0, height: 0))
    }
}

struct ProfileTabRouter: View {
    @EnvironmentObject private var container: AppContainer
    @EnvironmentObject private var session: SessionManager
    @ObservedObject var router: Router
    
    @State private var viewModel: ProfileViewModel?
    
    var body: some View {
        NavigationStack(path: $router.profilePath) {
            Group {
                if let stableViewModel = viewModel {
                    ProfileScreen(
                        viewModel: stableViewModel,
                        onNavigateToEditProfile: { router.push(.editProfile) },
                        onNavigateToSettings: { router.push(.mySettings) },
                        onNavigateToMyBusiness: { router.push(.myBusiness) },
                        onNavigateToUserProfile: { },
                        onNavigateToUserSocial: {
                            router.push(
                                .userSocial(
                                    userId: 13,
                                    username: "radu_ion",
                                    initialTab: .followers,
                                    isBusinessOrEmployee: true,
                                    initialFollowersCount: 100,
                                    initialFollowingsCount: 200
                                )
                            )
                        }
                    )
                } else {
                    LoadingView()
                }
            }
            .onAppear {
                if viewModel == nil {
                    viewModel = container.userProfileModule.makeProfileViewModel(session: session)
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                    // Global Routes
                    case .userSocial(
                        let userId,
                        let username,
                        let initialTab,
                        let isBusinessOrEmployee,
                        let initialFollowersCount,
                        let initialFollowingsCount
                    ):
                        SocialScreen(
                            viewModel: container.followModule.makeSocialViewModel(userId: userId),
                            username: username,
                            initialTab: initialTab,
                            isBusinessOrEmployee: isBusinessOrEmployee,
                            initialFollowersCount: initialFollowersCount,
                            initialFollowingsCount: initialFollowingsCount
                        )
                        .navigationBarHidden(true)
                    
                    // Settings
                    case .mySettings:
                        SettingsScreen { route in router.push(route)}
                        .navigationBarHidden(true)
                        
                    case .display:
                        DisplayScreen()
                        
                    case .reportProblem:
                        ReportProblemScreen(
                            viewModel: container.problemModule.makeProblemViewModel(userId: session.userInfo?.id ?? 0)
                        )
                        .navigationBarHidden(true)
                        
                        // Edit Profile
                    case .editProfile:
                        EditProfileScreen { route in router.push(route) }
                        .navigationBarHidden(true)
                        
                    case .editFullName:
                        EditNameScreen()
                        .navigationBarHidden(true)
                        
                    case .editUsername:
                        EditUsernameScreen()
                        .navigationBarHidden(true)
                        
                    case .editBio:
                        EditBioScreen()
                        .navigationBarHidden(true)
                        
                    case .editGender:
                        EditGenderScreen()
                        .navigationBarHidden(true)
                        
                    case .editBirthdate:
                        EditBirthdateScreen()
                        .navigationBarHidden(true)
                        
                        // My Business
                    case .myBusiness:
                        MyBusinessScreen() { route in router.push(route) }
                        .navigationBarHidden(true)
                        
                    case .myBusinessDetails:
                        MyBusinessDetailsScreen()
                        .navigationBarHidden(true)
                        
                    case .myCalendar:
                        MyCalendarScreen()
                        .navigationBarHidden(true)
                        
                    case .myProducts:
                        MyProductsScreen()
                        .navigationBarHidden(true)
                        
                    case .mySchedules:
                        MySchedulesScreen()
                        .navigationBarHidden(true)
                        
                    case .myServices:
                        MyServicesScreen(
                            viewModel: container.servieDomainModule.makeMyServicesViewModel(session: session)
                        )
                        .navigationBarHidden(true)
                    
                    case .myEmployees:
                        EmployeesFlowContainer(
                            container: container,
                            session: session
                        )
                        .navigationBarHidden(true)
                            
                    default: Text("Route not in Feed")
                }
            }
        }
        .toolbar(router.profilePath.isEmpty ? .visible : .hidden, for: .tabBar)
    }
}
