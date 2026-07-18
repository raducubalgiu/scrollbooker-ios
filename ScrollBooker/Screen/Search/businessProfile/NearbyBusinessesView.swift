//
//  NearbyBusinessesView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.07.2026.
//

import SwiftUI

struct NearbyBusinessesView: View {
    let businesses: [NearbyBusiness]?
    let onNavigateToBusinessProfile: (String) -> Void
    
    var body: some View {
        if let businesses = businesses, !businesses.isEmpty {
            VStack(alignment: .leading, spacing: 0) {
                Divider()
                
                Text(String(localized: "nearbyServices"))
                    .font(.title2.weight(.heavy))
                    .padding(.vertical)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 16) {
                        ForEach(businesses) { business in
                            NearbyBusinessItemView(
                                business: business,
                                onNavigateToBusinessProfile: onNavigateToBusinessProfile
                            )
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
