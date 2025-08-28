//
//  AppointmentCancelScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.08.2025.
//

import SwiftUI

struct AppointmentCancelScreen: View {
    let appointmentId: Int
    
    private var appointment: Appointment? {
        appointmentsList.first { $0.id == appointmentId }
    }
    
    var body: some View {
        FormLayout(
            headline: "Anuleaza rezervarea",
            subHeadline: "Feedbackul tau ne ajuta sa imbunatatim serviciile",
            buttonTitle: "Anuleaza"
        ) {

        }
    }
}

#Preview {
    AppointmentCancelScreen(appointmentId: 1)
}

