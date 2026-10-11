//
//  InboxTabRouter.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct InboxTabRouter: View {
    @Environment(AppContainer.self) private var container
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
                        onNavigateToUserProfile: { router.push(.userProfile($0)) },
                        onNavigateToEmploymentRequest: { router.push(.employmentRequestRespond(id: $0)) }
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
                    case .employmentRequestRespond(let id):
                        if let viewModel = inboxViewModel {
                            EmploymentRespondScreen(
                                employmentId: id,
                                viewModel: viewModel,
                                onBack: { router.pop() },
                                onNavigateToConsent: { router.push(.employmentRequestRespondConsent) },
                                onDenySuccess: { router.popToRoot() }
                            )
                        } else {
                            nil
                        }
                    case .employmentRequestRespondConsent:
                        if let viewModel = inboxViewModel {
                            EmploymentRespondConsentScreen(
                                viewModel: viewModel,
                                onBack: { router.pop() },
                                onAcceptSuccess: { router.popToRoot() }
                            )
                        } else {
                            nil
                        }
                    default:
                        nil
                    }
            }
        }
        .onChange(of: router.selectedTab, initial: true) { _, newTab in
            if newTab == .inbox && inboxViewModel == nil {
                inboxViewModel = container.notificationModule.makeNotificationsViewModel(
                    session: container.session,
                    getEmploymentRequestByIdUseCase: container.employmentRequestModule.getEmploymentRequestByIdUseCase,
                    respondEmploymentRequestUseCase: container.employmentRequestModule.respondEmploymentRequestUseCase,
                    getConsentByNameUseCase: container.consentModule.getConsentByNameUseCase,
                    refreshSessionUseCase: container.authModule.refreshSessionUseCase,
                    saveSessionUseCase: container.authModule.saveSessionUseCase
                )
            }
        }
    }
}

