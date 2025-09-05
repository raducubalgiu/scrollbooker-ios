//
//  AppointmentsTabRouter.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.08.2025.
//

import SwiftUI

struct AppointmentsTabRouter: View {
    @ObservedObject var router: Router
    
    var body: some View {
        NavigationStack(path: $router.appointmentsPath) {
            AppointmentsScreen(
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
