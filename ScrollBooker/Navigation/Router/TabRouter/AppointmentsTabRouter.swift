//
//  AppointmentsTabRouter.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.08.2025.
//

import SwiftUI

struct AppointmentsTabRouter: View {
    @EnvironmentObject private var session: SessionManager
    @ObservedObject var router: Router
    
    private let apiClient = APIClient(
        config: .init(baseURL: URL(string: "http://localhost:8000/api/v1")!)
    )
    
    var body: some View {
        let appointmentsAPI = AppointmentAPIImpl(client: apiClient)
        let viewModel = AppointmentsViewModel(api: appointmentsAPI, session: session)
        
        NavigationStack(path: $router.appointmentsPath) {
            AppointmentsScreen(
                viewModel: viewModel,
                onNavigateToAppointmentDetails: { id in
                    router.push(.appointmentDetails(id: id))
                }
            )
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .appointmentDetails(let id):
                        AppointmentDetailsScreen(
                            appointmentId: id,
                            onGoToCancel: { router.push(.appointmentCancel(id: id)) }
                        )
                        .toolbar(.hidden, for: .tabBar)
                    case .appointmentCancel(let id):
                        AppointmentCancelScreen(appointmentId: id)
                            .toolbar(.hidden, for: .tabBar)
                    default: Text("Route not in Appointments")
                    }
                }
        }
        .environmentObject(router)
    }
}
