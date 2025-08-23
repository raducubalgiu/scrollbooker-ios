//
//  SearchScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI
import MapKit

struct SearchScreen: View {
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 44.4269, longitude: 26.1025),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    
    let location = CLLocationCoordinate2D(latitude: 44.4269, longitude: 26.1025)
    
    var body: some View {
        VStack {
            Map(position: $position) {
                Marker("Centrul Bucurestiului", coordinate: location)
            }
            .frame(maxHeight: .infinity)
            .ignoresSafeArea()
        }
        .navigationBarHidden(true)
    }
}

#Preview("Light") {
    SearchScreen()
}

#Preview("Dark") {
    SearchScreen()
        .preferredColorScheme(.dark)
}
