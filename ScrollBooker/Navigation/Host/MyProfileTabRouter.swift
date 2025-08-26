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
                onNavigateToSettings: { router.push(.mySettings) }
            )
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .mySettings:
                        SettingsScreen { route in
                            router.push(route)
                        }
                        
                    case .account:
                        AccountScreen()
                        
                    case .privacy:
                        PrivacyScreen()
                        
                    case .security:
                        SecurityScreen()
                        
                    case .notificationSettings:
                        NotificationSettingsScreen()
                        
                    case .display:
                        DisplayScreen()
                        
                    case .reportProblem:
                        ReportProblemScreen()
                        
                    case .support:
                        SupportScreen()
                        
                    case .termsAndConditions:
                        TermsAndConditionsScreen()
                        
                    default: Text("This Route does not exist")
                    }
                }
        }
    }
}
