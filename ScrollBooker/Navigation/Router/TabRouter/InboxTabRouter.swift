//
//  InboxTabRouter.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct InboxTabRouter: View {
    @EnvironmentObject private var container: AppContainer
    @ObservedObject var router: Router
    
    @State private var inboxViewModel: InboxViewModel?
    
    var body: some View {
        NavigationStack(path: $router.inboxPath) {
            Group {
                if let viewModel = inboxViewModel {
                    InboxScreen(viewModel: viewModel)
                } else {
                    Color.clear
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                    case .employmentRequestRespond:
                        EmploymentRespondScreen()
                        
                    case .employmentRequestRespondConsent:
                        EmploymentRespondConsentScreen()
                        
                    default:
                        Text("Route not in Inbox")
                }
            }
        }
        .onAppear {
            if inboxViewModel == nil {
                inboxViewModel = container.notificationModule.makeNotificationsViewModel()
            }
        }
    }
}
