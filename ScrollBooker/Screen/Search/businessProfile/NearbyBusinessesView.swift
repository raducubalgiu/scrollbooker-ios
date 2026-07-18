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
                Text(String(localized: "nearbyServices"))
                    .font(.headline)
                    .padding(.vertical, .xl)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: AppSize.base.rawValue) {
                        ForEach(businesses) { business in
                            NearbyBusinessItemView(
                                business: business,
                                onNavigateToBusinessProfile: onNavigateToBusinessProfile
                            )
                            .contentMargins(.horizontal, AppSize.base.rawValue, for: .scrollContent)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
