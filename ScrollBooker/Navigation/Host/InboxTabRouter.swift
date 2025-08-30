//
//  InboxTabRouter.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct InboxTabRouter: View {
    @ObservedObject var router: Router
    
    var body: some View {
        NavigationStack(path: $router.inboxPath) {
            InboxScreen(
                onNavigateToEmployment: {
                    router.push(.employmentRequestRespond)
                }
            )
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .employmentRequestRespond:
                        EmploymentRespondScreen()
                            .navigationBarHidden(true)
                            .toolbar(.hidden, for: .tabBar)
                    case .employmentRequestRespondConsent:
                        EmploymentRespondConsentScreen()
                            .navigationBarHidden(true)
                            .toolbar(.hidden, for: .tabBar)
                        
                    default: Text("Route not in Feed")
                    }
                }
        }
    }
}
