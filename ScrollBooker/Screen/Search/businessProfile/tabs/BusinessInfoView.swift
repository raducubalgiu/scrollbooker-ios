//
//  BusinessInfoView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 02.09.2025.
//

import SwiftUI

struct BusinessInfoView: View {
    let profile: BusinessProfile
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 25) {
                // Mapare din owner.avatar
                AvatarView(imageURL: URL(string: profile.owner.avatar ?? ""), size: .xl)
                
                VStack(spacing: 15) {
                    HStack(spacing: 10) {
                        // Mapare din counters
                        ProfileCounterView(
                            counter: profile.owner.counters.followersCount,
                            label: String(localized: "followers"),
                            onClick: {}
                        )
                        
                        VerticalDivider(height: 20)
                            .padding(.horizontal)
                        
                        ProfileCounterView(
                            counter: profile.owner.counters.followingsCount,
                            label: String(localized: "following"),
                            onClick: {}
                        )
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            VStack(alignment: .leading, spacing: 7) {
                // Mapare din profile.owner.fullName sau numele afacerii tale
                Text(profile.owner.fullName)
                    .font(.title2.weight(.bold))
                
                // Mapare din location.address
                Text(profile.location.address)
                    .foregroundStyle(.secondary)
                
                // Afișare distanță opțională din profile.distanceKm
                if let distance = profile.distanceKm {
                    HStack(spacing: 8) {
                        Image(systemName: "location")
                        Text("la \(String(format: "%.1f", distance)) km de tine")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
                
                HStack(spacing: 8) {
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundStyle(.green)
                    Text("Deschis acum")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
        }
    }
}
