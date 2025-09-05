//
//  SearchScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI
import MapKit

struct SearchScreen: View {
    var onNavigateToBusinessProfile: (Int) -> Void
    
    @State private var isPresented = true
    
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 44.4269, longitude: 26.1025),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    
    let location = CLLocationCoordinate2D(latitude: 44.4269, longitude: 26.1025)
    
    let people = ["Chase", "John", "Jane", "Joe", "Jenny", "Jack", "Chase", "John", "Jane", "Joe", "Jenny", "Jack", "Chase", "John", "Jane", "Joe", "Jenny", "Jack", "Chase", "John", "Jane", "Joe", "Jenny", "Jack", "Chase", "John", "Jane", "Joe", "Jenny", "Jack", "Chase", "John", "Jane", "Joe", "Jenny", "Jack", "Chase", "John", "Jane", "Joe", "Jenny", "Jack", "Chase", "John", "Jane", "Joe", "Jenny", "Jack", "Chase", "John", "Jane", "Joe", "Jenny", "Jack", "Chase", "John", "Jane", "Joe", "Jenny", "Jack"]
    
    var body: some View {
        VStack {
            Map(position: $position) {
                Marker("Centrul Bucurestiului", coordinate: location)
            }
            .frame(maxHeight: .infinity)
            .ignoresSafeArea()
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $isPresented) {
            ScrollView {
                LazyVStack {
                    ForEach(Array(people.enumerated()), id: \.offset) { index, person in
                        HStack {
                            Text("\(person), \(index)")
                            
                            Spacer()
                            
                            Button {
                                isPresented = false
                                onNavigateToBusinessProfile(1)
                            } label: {
                                Text("Business")
                            }
                            .padding(.vertical)
                        }
                        .padding(.horizontal)
//                        .onTapGesture {
//                            print("Pressed!!!")
//                            onNavigateToBusinessProfile(1)
//                        }
                    }
                }
                .padding(.top, 8)
                .padding(.bottom)
            }
            .padding(.top, .s)
            .padding(.bottom)
            //.interactiveDismissDisabled()
            .presentationDetents([.medium, .large])
            //.presentationContentInteraction(.scrolls)
            .presentationDragIndicator(.visible)
            .presentationCornerRadius(25)
        }
    }
}

#Preview("Light") {
    SearchScreen(
        onNavigateToBusinessProfile: {_ in }
    )
}

#Preview("Dark") {
    SearchScreen(
        onNavigateToBusinessProfile: {_ in }
    )
        .preferredColorScheme(.dark)
}
