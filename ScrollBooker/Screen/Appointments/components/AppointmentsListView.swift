//
//  AppointmentsListView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

import SwiftUI

struct AppointmentsListView: View {
    let appointments: [Appointment]
    let isPaging: Bool

    let onNavigateToAppointmentDetails: (Int) -> Void
    let onItemAppear: (Appointment) -> Void
    let onRefresh: () async -> Void

    var body: some View {
        let lastId = appointments.last?.id

        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(appointments) { appointment in
                    AppointmentCardView(
                        appointment: appointment,
                        onClick: { onNavigateToAppointmentDetails(appointment.id) }
                    )
                    .onAppear {
                        guard appointment.id == lastId else { return }
                        onItemAppear(appointment)
                    }

                    if appointment.id != lastId {
                        Divider()
                    }
                }

                if isPaging {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                }
            }
            .padding(.top, 12)
        }
        .refreshable {
            await onRefresh()
        }
    }
}
