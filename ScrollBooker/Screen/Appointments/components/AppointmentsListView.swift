//
//  AppointmentsListView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

import SwiftUI

struct AppointmentsListView: View {
    let appointments: [Appointment]
    let onNavigateToAppointmentDetails: (Int) -> Void
    let onItemAppear: (Appointment) -> Void

    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(appointments) { appointment in
                AppointmentCardView(
                    appointment: appointment,
                    onClick: {
                        onNavigateToAppointmentDetails(appointment.id)
                    }
                )
                .onAppear {
                    onItemAppear(appointment)
                }

                Divider()
            }
        }
    }
}
