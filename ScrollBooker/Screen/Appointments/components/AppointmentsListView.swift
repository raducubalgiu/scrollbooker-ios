//
//  AppointmentsListView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

import SwiftUI

struct AppointmentsListView: View {
    let appointments: [Appointment]
    var isPaging: Bool = false
    
    let onNavigateToAppointmentDetails: (Int) -> Void
    let onItemAppear: (Appointment) -> Void
    let onRefresh: () async -> Void

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
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

                    if appointment.id != appointments.last?.id {
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
