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
    var onGoToCancel: () -> Void
    
    private var appointment: Appointment? {
        appointmentsList.first { $0.id == appointmentId }
    }
    
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 44.4269, longitude: 26.1025),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    
    private var location: CLLocationCoordinate2D? {
        guard let coordinates = appointment?.business.coordinates else { return  nil}
        return CLLocationCoordinate2D(
            latitude: coordinates.lat,
            longitude: coordinates.lng
        )
    }
    
    var body: some View {
        Header(
            title: String(localized: "bookingDetails")
        )
        
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                if(appointment != nil) {
                    AppointmentCardView(
                        padding: 0,
                        appointment: appointment!,
                        onClick: {}
                    )
                }
                
                if(appointment?.status != .cancelled) {
    //                MainButton(title: "Rezerva din nou", onClick: {})
                    
                    MainButton(
                        title: String(localized: "cancelAppointment"),
                        onClick: onGoToCancel,
                        bgColor: .errorSB
                    )
                } else {
                    HStack {
                        Image(systemName: "exclamationmark.triangle")
                            .foregroundColor(.errorSB)
                        Text("\(String(localized: "cancelReason")): \(appointment?.message ?? "")")
                            .foregroundColor(.errorSB)
                    }
                    .padding(.vertical)
                }
                
                Text("location")
                    .font(.headline.bold())
                
                HStack {
                    Image(systemName: "location")
                    Text(appointment?.business.address ?? "")
                }
                
                if let coord = location {
                    Map(position: $position) {
                        Marker("Centrul Bucurestiului", coordinate: coord)
                    }
                    .frame(height: 220)
                    .padding(.top, .base)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .onAppear {
                        position = .region(MKCoordinateRegion(
                            center: coord,
                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                        ))
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .navigationBarHidden(true)
        }
    }
}

#Preview("Light") {
    AppointmentDetailsScreen(
        appointmentId: 1,
        onGoToCancel: {}
    )
}

#Preview("Dark") {
    AppointmentDetailsScreen(
        appointmentId: 1,
        onGoToCancel: {}
    )
        .preferredColorScheme(.dark)
}
