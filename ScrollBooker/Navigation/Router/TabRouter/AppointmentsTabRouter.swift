//
//  AppointmentsTabRouter.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.08.2025.
//

import SwiftUI

struct AppointmentsTabRouter: View {
    @EnvironmentObject private var container: AppContainer
    @ObservedObject var router: Router
    @State private var viewModel: AppointmentsViewModel?

    var body: some View {
        NavigationStack(path: $router.appointmentsPath) {
            Group {
                if let viewModel = viewModel {
                    AppointmentsScreen(
                        viewModel: viewModel,
                        onNavigateToAppointmentDetails: { id in router.push(.appointmentDetails(id: id)
                        )
                }
            )} else {
                    ProgressView()
                }
            }
            .withGlobalNavigation()
        }
        .toolbar(router.appointmentsPath.isEmpty ? .visible : .hidden, for: .tabBar)
        .onAppear {
            if viewModel == nil {
                viewModel = container.appointmentModule.makeAppointmentsViewModel()
            }
        }
    }
}

