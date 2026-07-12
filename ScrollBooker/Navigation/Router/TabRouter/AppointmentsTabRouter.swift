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
                } else {
                    ProgressView()
                }
            }
            .withGlobalNavigation()
        }
        .toolbar(router.appointmentsPath.isEmpty ? .visible : .hidden, for: .tabBar)
        .onAppear {
            if viewModel == nil {
                Task { @MainActor in
                    viewModel = container.appointmentModule.makeAppointmentsViewModel()
                }
            }
        }
    }
}

