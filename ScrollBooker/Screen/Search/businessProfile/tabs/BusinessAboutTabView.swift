//
//  BusinessAboutTabView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 02.09.2025.
//

import SwiftUI

struct BusinessAboutTabView: View {
    let description: String?
    let schedules: [Schedule]
    let location: BusinessLocation
    let fullName: String
    let nearbyBusinesses: [NearbyBusiness]
    let onNavigateToBusinessProfile: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(String(localized: "about"))
                .font(.title2.weight(.heavy))
                .padding(.bottom)
            
            Text(description ?? "Acest business nu are o descriere")
            
            Text(String(localized: "schedule"))
                .font(.title2.weight(.heavy))
                .padding(.vertical)
            
            ForEach(schedules) { schedule in
                HStack {
                    HStack {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 10, height: 10)
                        Text(schedule.localizedDayOfWeek)
                            .font(.headline)
                    }
                    
                    Spacer()
                    
                    Text("\(String(describing: schedule.startTime)) - \(String(describing: schedule.endTime))")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
            }
            
            Text(String(localized: "address"))
                .font(.title2.weight(.heavy))
                .padding(.vertical)
            
            Text(location.address)
            
            if let mapUrl = location.mapUrl {
                SectionMap(
                    mapUrl: mapUrl,
                    coordinates: location.coordinates,
                    fullName: fullName
                )
            }
            
            NearbyBusinessesView(
                businesses: nearbyBusinesses,
                onNavigateToBusinessProfile: onNavigateToBusinessProfile
            )
        }
        .padding(16)
        .background(Color(.systemBackground))
    }
}
