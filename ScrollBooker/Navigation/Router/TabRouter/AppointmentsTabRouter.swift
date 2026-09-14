//
//  AppointmentsTabRouter.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.08.2025.
//

import SwiftUI

struct AppointmentsTabRouter: View {
    @Environment(AppContainer.self) private var container
    var router: Router
    @State private var viewModel: AppointmentsViewModel?

    var body: some View {
        @Bindable var bindableRouter = router
        
        NavigationStack(path: $bindableRouter.appointmentsPath) {
            Group {
                if let viewModel = viewModel {
                    AppointmentsScreen(
                        viewModel: viewModel,
                        onNavigateToAppointmentDetails: { id in
                            router.push(.appointmentDetails(id: id))
                        }
                    )
                    .safeAreaInset(edge: .bottom, spacing: 0) {
                        CustomTabBar(backgroundColor: .backgroundSB)
                    }
                } else {
                    ProgressView()
                }
            }
            .withGlobalNavigation()
        }
        .onChange(of: router.selectedTab, initial: true) { _, newTab in
            if newTab == .appointments && viewModel == nil {
                Task {
                    @MainActor in
                        viewModel = container.appointmentModule.makeAppointmentsViewModel()
                }
            }
        }
    }
}

