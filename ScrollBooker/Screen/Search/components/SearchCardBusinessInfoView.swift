//
//  SearchCardBusinessInfoView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.07.2026.
//

import SwiftUI

struct SearchCardBusinessInfo: View {
    let fullName: String
    let ratingsAverage: Float
    let ratingsCount: Int
    let profession: String
    let address: String
    let distance: Float?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center) {
                Text(fullName)
                    .font(.system(size: 18, weight: .semibold))
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.ratingSB)
                    
                    Text(ratingsAverage.formatRating())
                        .fontWeight(.bold)
                    
                    Text("(\(ratingsCount))")
                        .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: .infinity)
            
            Text(profession)
                .font(.body)
                .foregroundColor(.gray)
            
            Spacer().frame(height: 8)
            
            HStack(alignment: .center, spacing: 0) {
                if let distance = distance {
                    Text("\(String(format: "%.1f", distance)) km")
                        .foregroundColor(.gray)
                        .lineLimit(1)
                    
                    Text("  \u{2022}  ")
                        .foregroundColor(.gray)
                }
                
                Text(address)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.65, alignment: .leading)
            }
        }
    }
}
