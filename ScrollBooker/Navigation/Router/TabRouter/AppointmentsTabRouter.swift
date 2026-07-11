//
//  AppointmentsTabRouter.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.08.2025.
//

import SwiftUI

struct AppointmentsTabRouter: View {
    @EnvironmentObject private var container: AppContainer
    @EnvironmentObject private var session: SessionManager
    @ObservedObject var router: Router

    @State private var viewModel: AppointmentsViewModel?

    var body: some View {
        NavigationStack(path: $router.appointmentsPath) {
            Group {
                if let viewModel = viewModel {
                    AppointmentsScreen(
                        viewModel: viewModel,
                        onNavigateToAppointmentDetails: { id in
                            router.push(.appointmentDetails(id: id))
                        }
                    )
                } else {
                    Color.clear
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                    case .appointmentDetails(let id):
                        AppointmentDetailsScreen(
                            viewModel: container.appointmentModule.makeAppointmentDetailsViewModel(
                                appointmentId: id,
                                session: session,
                                createReviewUseCase: container.reviewModule.createReviewUseCase,
                                updateReviewUseCase: container.reviewModule.updateReviewUseCase
                            )
                        )
                        .navigationBarHidden(true)

                    default:
                        Text("Route not in Appointments")
                    }
                }
            }
            .environmentObject(router)
            .toolbar(router.appointmentsPath.isEmpty ? .visible : .hidden, for: .tabBar)
            .onAppear {
                if viewModel == nil {
                    viewModel = container.appointmentModule.makeAppointmentsViewModel()
                }
            }
    }
}
