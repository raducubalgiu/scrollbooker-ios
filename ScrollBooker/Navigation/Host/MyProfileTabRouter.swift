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
                onNavigateToMyBusiness: { router.push(.myBusiness) }
            )
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .mySettings:
                        SettingsScreen { route in router.push(route)}
                            .navigationBarHidden(true)
                        
                    case .account:
                        AccountScreen()
                            .navigationBarHidden(true)
                        
                    case .privacy:
                        PrivacyScreen()
                            .navigationBarHidden(true)
                        
                    case .security:
                        SecurityScreen()
                            .navigationBarHidden(true)
                        
                    case .notificationSettings:
                        NotificationSettingsScreen()
                            .navigationBarHidden(true)
                        
                    case .display:
                        DisplayScreen()
                            .navigationBarHidden(true)
                        
                    case .reportProblem:
                        ReportProblemScreen()
                            .navigationBarHidden(true)
                        
                    case .support:
                        SupportScreen()
                            .navigationBarHidden(true)
                        
                    case .termsAndConditions:
                        TermsAndConditionsScreen()
                            .navigationBarHidden(true)
                        
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
                        
                    case .myBusiness:
                        MyBusinessScreen { route in router.push(route) }
                            .navigationBarHidden(true)
                        
                    case .myCalendar:
                        MyCalendarScreen()
                            .navigationBarHidden(true)
                        
                    case .myCurrencies:
                        MyCurrenciesScreen()
                            .navigationBarHidden(true)
                        
                    case .myEmployees:
                        MyEmployeesScreen()
                            .navigationBarHidden(true)
                        
                    case .myProducts:
                        MyProductsScreen()
                            .navigationBarHidden(true)
                        
                    case .mySchedules:
                        MySchedulesScreen()
                            .navigationBarHidden(true)
                        
                    case .myServices:
                        MyServicesScreen()
                            .navigationBarHidden(true)
                        
                    default: Text("This Route does not exist")
                    }
                }
        }
    }
}
