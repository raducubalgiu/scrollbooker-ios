//
//  AppointmentDetailsScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.08.2025.
//

import SwiftUI

struct AppointmentDetailsScreen: View {
    let appointmentId: Int
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Detalii rezervare")
                .font(.title3)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                AppointmentCard(
                    padding: 0,
                    onClick: {}
                )
                
                MainButton(title: "Rezerva din nou", onClick: {})
                
                Text("Locatie")
                    .font(.headline.bold())
                
                HStack {
                    Image(systemName: "location")
                    Text("Bulevardul Iuliu Maniu 67, Bucuresti, 077042, Romania")
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
    }
}

#Preview("Light") {
    AppointmentDetailsScreen(appointmentId: 1)
}

#Preview("Dark") {
    AppointmentDetailsScreen(appointmentId: 1)
        .preferredColorScheme(.dark)
}
