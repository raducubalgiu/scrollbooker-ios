//
//  AppointmentsTabRouter.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.08.2025.
//

import SwiftUI

struct AppointmentsTabRouter: View {
    @EnvironmentObject private var container: AppContainer
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

