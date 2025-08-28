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
    
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 44.4269, longitude: 26.1025),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    
    let location = CLLocationCoordinate2D(latitude: 44.4269, longitude: 26.1025)
    
    var body: some View {
        Header(
            title: "Detalii rezervare"
        )
        
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                AppointmentCardView(
                    padding: 0,
                    appointment: Appointment(
                        id: 3,
                        startDate: Date(),
                        endDate: Date().addingTimeInterval(3600),
                        channel: "scroll_booker",
                        status: AppointmentStatus(raw: "cancelled"),
                        message: "Am gasit o oferta mai buna",
                        product: AppointmentProduct(
                            id: 2,
                            name: "Curs de dans bachata",
                            price: 100.0,
                            priceWithDiscount: 50.0,
                            discount: 0.0,
                            currency: "RON",
                            exchangeRate: 1.0
                        ),
                        user: AppointmentUser(
                            id: 2,
                            avatar: "https://media.scrollbooker.ro/avatar-male-9.jpeg",
                            fullName: "Salsa Factory",
                            username: "@salsa_factory",
                            profession: "Scoala de dans"
                        ),
                        isCustomer: true,
                        business: AppointmentBusiness(
                            address: "Bulevardul Iuliu Maniu 67, Bucuresti, 077042, Romania",
                            coordinates: BusinessCoordinates(
                                lat: 26.020075,
                                lng: 44.433552
                            )
                        )
                    ),
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
