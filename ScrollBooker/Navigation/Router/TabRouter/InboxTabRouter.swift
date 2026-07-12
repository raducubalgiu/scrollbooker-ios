//
//  InboxTabRouter.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct InboxTabRouter: View {
    @EnvironmentObject private var container: AppContainer
    var router: Router
    @State private var inboxViewModel: InboxViewModel?
    
    var body: some View {
        @Bindable var bindableRouter = router
        
        NavigationStack(path: $bindableRouter.inboxPath) {
            Group {
                if let viewModel = inboxViewModel {
                    InboxScreen(
                        viewModel: viewModel,
                        onNavigateToAppointmentDetails: { id in router.push(.appointmentDetails(id: id)) },
                        onNavigateToUserProfile: { id, username in router.push(.userProfile(userId: id, username: username)) }
                    )
                } else {
                    ProgressView()
                }
            }
            .withNavigation { route in
                switch route {
                    case .employmentRequestRespond:
                        EmploymentRespondScreen(
                            onBack: { router.pop() }
                        )
                    case .employmentRequestRespondConsent:
                        EmploymentRespondConsentScreen(
                            onBack: { router.pop() }
                        )
                    default:
                        nil
                    }
            }
        }
        .toolbar(router.inboxPath.isEmpty ? .visible : .hidden, for: .tabBar)
        .onAppear {
            if inboxViewModel == nil {
                Task { @MainActor in
                    inboxViewModel = container.notificationModule.makeNotificationsViewModel()
                }
            }
        }
    }
}

