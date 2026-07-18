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
            Text(description ?? "Acest business nu are o descriere")
                .font(.body)
                .padding(.bottom, 8)
 
            Text(String(localized: "schedule"))
                .font(.title2.weight(.heavy))
                .padding(.vertical, 8)
            
            ForEach(schedules) { schedule in
                HStack {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 10, height: 10)
                        Text(schedule.localizedDayOfWeek)
                            .font(.headline)
                    }
                    
                    Spacer()
                    
                    Text("\(schedule.startTime) - \(schedule.endTime)")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 4)
            }
            
            // 3. Adresa și Harta
            Text(String(localized: "address"))
                .font(.title2.weight(.heavy))
                .padding(.vertical, 8)
            
            Text(location.address)
                .font(.body)
                .foregroundColor(.secondary)
            
            if let mapUrl = location.mapUrl {
                SectionMap(
                    mapUrl: mapUrl,
                    coordinates: location.coordinates,
                    fullName: fullName
                )
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.vertical, 8)
            }
            
            NearbyBusinessesView(
                businesses: nearbyBusinesses,
                onNavigateToBusinessProfile: onNavigateToBusinessProfile
            )
            .padding(.top, 16)
        }
    }
}
