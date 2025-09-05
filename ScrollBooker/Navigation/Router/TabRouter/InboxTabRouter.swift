//
//  InboxTabRouter.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct InboxTabRouter: View {
    @EnvironmentObject private var session: SessionManager
    @ObservedObject var router: Router
    
    private let apiClient = APIClient(
        config: .init(baseURL: URL(string: "http://localhost:8000/api/v1")!)
    )
    
    var body: some View {
        let notificationAPI = NotificationAPIImpl(client: apiClient)
        let viewModel = InboxViewModel(api: notificationAPI, session: session)
        
        NavigationStack(path: $router.inboxPath) {
            InboxScreen(
                viewModel: viewModel
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
