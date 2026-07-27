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
                        onNavigateToAppointmentDetails: { router.push(.appointmentDetails(id: $0)) },
                        onNavigateToUserProfile: { router.push(.userProfile($0)) }
                    )
                    .safeAreaInset(edge: .bottom, spacing: 0) {
                        CustomTabBar(backgroundColor: .backgroundSB)
                    }
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
        .onChange(of: router.selectedTab, initial: true) { _, newTab in
            if newTab == .inbox && inboxViewModel == nil {
                Task {
                    @MainActor in inboxViewModel = container.notificationModule.makeNotificationsViewModel()
                }
            }
        }
    }
}

