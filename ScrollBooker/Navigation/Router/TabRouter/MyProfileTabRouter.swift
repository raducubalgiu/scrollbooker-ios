//
//  §TabRouter.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.08.2025.
//

import SwiftUI

struct MyProfileTabRouter: View {
    @EnvironmentObject private var container: AppContainer
    @EnvironmentObject private var session: SessionManager
    @ObservedObject var router: Router
    
    var body: some View {
        NavigationStack(path: $router.profilePath) {
            MyProfileScreen(
                onNavigateToEditProfile: { router.push(.editProfile) },
                onNavigateToSettings: { router.push(.mySettings) },
                onNavigateToMyBusiness: { router.push(.myBusiness) },
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
                },
                onNavigateToUserProfile: { router.push(.userProfile) }
            )
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
                            .toolbar(.hidden, for: .tabBar)
                        
                        // Settings
                        case .mySettings:
                            SettingsScreen { route in router.push(route)}
                                .navigationBarHidden(true)
                                .toolbar(.hidden, for: .tabBar)
                            
                        case .display:
                            DisplayScreen()
                                .navigationBarHidden(true)
                                .toolbar(.hidden, for: .tabBar)
                            
                        case .reportProblem:
                            ReportProblemScreen(
                                viewModel: container.problemModule.makeProblemViewModel(userId: session.userInfo?.id ?? 0)
                            )
                                .navigationBarHidden(true)
                                .toolbar(.hidden, for: .tabBar)
                            
                        // Edit Profile
                        case .editProfile:
                            EditProfileScreen { route in router.push(route) }
                                .navigationBarHidden(true)
                                .toolbar(.hidden, for: .tabBar)
                        
                        case .editFullName:
                            EditNameScreen()
                                .navigationBarHidden(true)
                                .toolbar(.hidden, for: .tabBar)
                            
                        case .editUsername:
                            EditUsernameScreen()
                                .navigationBarHidden(true)
                                .toolbar(.hidden, for: .tabBar)
                            
                        case .editBio:
                            EditBioScreen()
                                .navigationBarHidden(true)
                                .toolbar(.hidden, for: .tabBar)
                        
                        case .editGender:
                            EditGenderScreen()
                                .navigationBarHidden(true)
                                .toolbar(.hidden, for: .tabBar)
                        
                        case .editBirthdate:
                            EditBirthdateScreen()
                                .navigationBarHidden(true)
                                .toolbar(.hidden, for: .tabBar)
                        
                        // My Business
                        case .myBusiness:
                            MyBusinessScreen { route in router.push(route) }
                                .navigationBarHidden(true)
                                .toolbar(.hidden, for: .tabBar)
                        
                        case .myBusinessDetails:
                            MyBusinessDetailsScreen()
                                .navigationBarHidden(true)
                                .toolbar(.hidden, for: .tabBar)
                            
                        case .myCalendar:
                            MyCalendarScreen()
                                .navigationBarHidden(true)
                                .toolbar(.hidden, for: .tabBar)
                            
                        case .myCurrencies:
                            MyCurrenciesScreen()
                                .navigationBarHidden(true)
                                .toolbar(.hidden, for: .tabBar)
                            
                        case .myProducts:
                            MyProductsScreen()
                                .navigationBarHidden(true)
                                .toolbar(.hidden, for: .tabBar)
                            
                        case .mySchedules:
                            MySchedulesScreen()
                                .navigationBarHidden(true)
                                .toolbar(.hidden, for: .tabBar)
                            
                        case .myServices:
                            MyServicesScreen()
                                .navigationBarHidden(true)
                                .toolbar(.hidden, for: .tabBar)
                            
                        case .myEmployees:
                            MyEmployeesScreen()
                                .navigationBarHidden(true)
                                .toolbar(.hidden, for: .tabBar)
                        
                        case .employmentSelectEmployee:
                            EmploymentSelectEmployeeScreen()
                                .navigationBarHidden(true)
                                .toolbar(.hidden, for: .tabBar)
                            
                        case .employmentAssignJob:
                            EmploymentAsignJobScreen()
                                .navigationBarHidden(true)
                                .toolbar(.hidden, for: .tabBar)
                            
                        case .employmentAcceptTerms:
                            EmploymentAcceptTermsScreen()
                                .navigationBarHidden(true)
                                .toolbar(.hidden, for: .tabBar)
//
//                        case .userProfile:
//                            UserProfileScreen(
//                                onNavigateToEditProfile: { router.push(.editProfile) },
//                                onNavigateToSettings: { router.push(.mySettings) },
//                                onNavigateToMyBusiness: { router.push(.myBusiness) },
//                                onNavigateToUserSocial: {
//                                    router.push(
//                                        .userSocial(
//                                            userId: 13,
//                                            username: "radu_ion",
//                                            initialTab: SocialTab.followers,
//                                            isBusinessOrEmployee: true,
//                                            initialFollowersCount: 100,
//                                            initialFollowingsCount: 200
//                                        )
//                                    )
//                                },
//                                onNavigateToUserProfile: { router.push(.userProfile) }
//                            )
//                                .navigationBarHidden(true)
//                                .toolbar(.hidden, for: .tabBar)
//                                .ignoresSafeArea(.container, edges: .bottom)
                            
                        default: Text("This Route does not exist")
                    }
                }
        }
    }
}
