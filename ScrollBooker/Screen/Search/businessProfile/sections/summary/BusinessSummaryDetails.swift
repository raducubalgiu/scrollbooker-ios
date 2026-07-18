//
//  BusinessSummaryDetails.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.07.2026.
//

import SwiftUI

struct BusinessSummaryDetails: View {
    let distance: Float?
    let fullName: String
    let address: String
    let openingHours: OpeningHours
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(fullName)
                .font(.headline.bold())
            
            HStack(alignment: .center, spacing: 0) {
                if let distance = distance {
                    Text("\(String(format: "%.1f", distance))km")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                    
                    Text("  \u{2022}  ")
                        .foregroundColor(.gray)
                }
                
                Text(address)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            .padding(.bottom, .m)

            HStack(alignment: .center, spacing: 0) {
                Text(openingHours.openNow ? String(localized: "open") : String(localized: "closed"))
                    .font(.footnote)
                    .foregroundColor(.onBackgroundSB)
                
                Text("  \u{2022}  ")
                    .foregroundColor(.gray)
                
                Text(formatOpeningHours(openingHours))
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func formatOpeningHours(_ hours: OpeningHours) -> String {
        return "09:00 - 21:00"
    }
}
