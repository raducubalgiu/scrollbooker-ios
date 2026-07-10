//
//  ReviewCTA.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.07.2026.
//

import SwiftUI

struct ReviewCTA: View {
    var onRatingClick: (Int) -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Text(String(localized: "clickOnRatingToEvaluate"))
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack(spacing: 5) {
                ForEach(1...5, id: \.self) { rating in
                    Image(systemName: "star")
                        .font(.system(size: 28))
                        .foregroundColor(.gray)
                        .frame(width: 40, height: 40)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            onRatingClick(rating)
                        }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .padding(.horizontal, 16)
        .background(Color(.secondarySystemBackground)) // Corespondentul SurfaceBG
        .cornerRadius(12)
    }
}
