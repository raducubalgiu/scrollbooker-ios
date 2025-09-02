//
//  Map.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 02.09.2025.
//

import SwiftUI
import MapKit

struct MapView: View {
    var businessCoordinates: BusinessCoordinates
    
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 44.4269, longitude: 26.1025),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    
    private var location: CLLocationCoordinate2D? {
        return CLLocationCoordinate2D(
            latitude: businessCoordinates.lat,
            longitude: businessCoordinates.lng
        )
    }
    
    var body: some View {
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
}

#Preview("Light") {
    MapView(
        businessCoordinates: BusinessCoordinates(lat: 45.23455, lng: 25.23456)
    )
}
