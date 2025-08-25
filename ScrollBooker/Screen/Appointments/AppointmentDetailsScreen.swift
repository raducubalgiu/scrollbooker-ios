//
//  AppointmentDetailsScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.08.2025.
//

import SwiftUI
import MapKit

struct AppointmentDetailsScreen: View {
    let appointmentId: Int
    var onBack: () -> Void
    var onGoToCancel: () -> Void
    
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 44.4269, longitude: 26.1025),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    
    let location = CLLocationCoordinate2D(latitude: 44.4269, longitude: 26.1025)
    
    var body: some View {
        Header(
            title: "Detalii rezervare",
            onBack: onBack
        )
        
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                AppointmentCard(
                    padding: 0,
                    onClick: {}
                )
                
//                MainButton(title: "Rezerva din nou", onClick: {})
                
                MainButton(
                    title: "Anuleaza rezervarea",
                    onClick: onGoToCancel,
                    bgColor: .errorSB
                )
                
                Text("Locatie")
                    .font(.headline.bold())
                
                HStack {
                    Image(systemName: "location")
                    Text("Bulevardul Iuliu Maniu 67, Bucuresti, 077042, Romania")
                }
                
                Map(position: $position) {
                    Marker("Centrul Bucurestiului", coordinate: location)
                }
                .frame(height: 220)
                .cornerRadius(8)
                .padding(.top, .base)
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
    }
}

#Preview("Light") {
    AppointmentDetailsScreen(
        appointmentId: 1,
        onBack: {},
        onGoToCancel: {}
    )
}

#Preview("Dark") {
    AppointmentDetailsScreen(
        appointmentId: 1,
        onBack: {},
        onGoToCancel: {}
    )
        .preferredColorScheme(.dark)
}
