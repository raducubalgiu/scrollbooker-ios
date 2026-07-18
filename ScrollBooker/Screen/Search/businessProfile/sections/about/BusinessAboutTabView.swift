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
                .font(.headline)
                .padding(.vertical, 8)
            
            SchedulesSection(schedules: schedules)
            
            Text(String(localized: "address"))
                .font(.headline)
                .padding(.vertical, 8)
            
            Text(location.address)
                .font(.body)
                .foregroundColor(.secondary)
            
            if let mapUrl = location.mapUrl {
                SectionMap(
                    mapUrl: mapUrl,
                    coordinates: location.coordinates,
                    fullName: fullName,
                    displayDirectionsButton: false
                )
            }
            
            Divider().padding(.top, .base)
            
            NearbyBusinessesView(
                businesses: nearbyBusinesses,
                onNavigateToBusinessProfile: onNavigateToBusinessProfile
            )
        }
        .padding(.horizontal, .base)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
