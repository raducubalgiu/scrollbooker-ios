//
//  MyProfileTabRouter.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.08.2025.
//

import SwiftUI

struct MyProfileTabRouter: View {
    @ObservedObject var router: Router
    
    var body: some View {
        NavigationStack(path: $router.profilePath) {
            MyProfileScreen(
                onNavigateToEditProfile: { router.push(.editProfile) },
                onNavigateToSettings: { router.push(.mySettings) },
                onNavigateToMyBusiness: { router.push(.myBusiness) },
                onNavigateToUserSocial: { router.push(.userSocial) }
            )
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .mySettings:
                        SettingsScreen { route in router.push(route)}
                            .navigationBarHidden(true)
                            .toolbar(.hidden, for: .tabBar)
                        
                    case .account:
                        AccountScreen()
                            .navigationBarHidden(true)
                            .toolbar(.hidden, for: .tabBar)
                        
                    case .privacy:
                        PrivacyScreen()
                            .navigationBarHidden(true)
                            .toolbar(.hidden, for: .tabBar)
                        
                    case .security:
                        SecurityScreen()
                            .navigationBarHidden(true)
                            .toolbar(.hidden, for: .tabBar)
                        
                    case .notificationSettings:
                        NotificationSettingsScreen()
                            .navigationBarHidden(true)
                            .toolbar(.hidden, for: .tabBar)
                        
                    case .display:
                        DisplayScreen()
                            .navigationBarHidden(true)
                            .toolbar(.hidden, for: .tabBar)
                        
                    case .reportProblem:
                        ReportProblemScreen()
                            .navigationBarHidden(true)
                            .toolbar(.hidden, for: .tabBar)
                        
                    case .support:
                        SupportScreen()
                            .navigationBarHidden(true)
                            .toolbar(.hidden, for: .tabBar)
                        
                    case .termsAndConditions:
                        TermsAndConditionsScreen()
                            .navigationBarHidden(true)
                            .toolbar(.hidden, for: .tabBar)
                        
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
                        
                    case .myBusiness:
                        MyBusinessScreen { route in router.push(route) }
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
                        
                    case .myEmployees:
                        MyEmployeesScreen()
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
                        
                    case .userSocial:
                        SocialScreen()
                            .navigationBarHidden(true)
                            .toolbar(.hidden, for: .tabBar)
                        
                    default: Text("This Route does not exist")
                    }
                }
        }
    }
}
