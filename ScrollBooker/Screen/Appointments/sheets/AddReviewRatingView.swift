//
//  AddReviewSectionView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

import SwiftUI

struct AddReviewRatingView: View {
    let selectedRating: Int?
    var onRatingClick: (Int) -> Void
    let ratingLabel: String
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(1...5, id: \.self) { rating in
                    let isFilled = selectedRating != nil && rating <= selectedRating!
                    
                    Image(systemName: isFilled ? "star.fill" : "star")
                        .font(.system(size: 30))
                        .foregroundColor(isFilled ? .primarySB : .dividerSB)
                        .frame(width: 40, height: 40)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            onRatingClick(rating)
                        }
                }
            }
            
            Spacer().frame(height: 16)
            
            HStack(spacing: 8) {
                Text("\(selectedRating ?? 0) \(String(localized: "from5"))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text("•")
                    .foregroundColor(.gray)
                
                Text(ratingLabel)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}
