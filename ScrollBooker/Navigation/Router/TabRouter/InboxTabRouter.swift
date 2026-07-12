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
                    InboxScreen(viewModel: viewModel, onNavigateToAppointmentDetails: { id in
                        router.push(.appointmentDetails(id: id))
                    })
                } else {
                    ProgressView()
                }
            }
            .withNavigation { route in
                switch route {
                    case .employmentRequestRespond:
                        EmploymentRespondScreen(
                            onBack: { router.pop() },
                        )
                            .toolbar(.hidden, for: .navigationBar)
                        
                    case .employmentRequestRespondConsent:
                        EmploymentRespondConsentScreen(
                            onBack: { router.pop() },
                        )
                            .toolbar(.hidden, for: .navigationBar)
                    default:
                        nil
                    }
            }
        }
        .toolbar(router.inboxPath.isEmpty ? .visible : .hidden, for: .tabBar)
        .onAppear {
            if inboxViewModel == nil {
                inboxViewModel = container.notificationModule.makeNotificationsViewModel()
            }
        }
    }
}
