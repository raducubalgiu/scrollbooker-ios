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
            AppointmentsScreen()
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .appointments:
                        AppointmentsScreen()
                    case .appointmentDetails(let id):
                        AppointmentDetailsScreen(
                            appointmentId: id,
                            onGoToCancel: { router.toAppointmentCancel(id: id) }
                        )
                    case .appointmentCancel(let id):
                        AppointmentCancelScreen(appointmentId: id)
                    default: Text("Route not in Appointments")
                    }
                }
        }
        .environmentObject(router)
    }
}
