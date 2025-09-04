//
//  StartRatingView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 29.08.2025.
//

import SwiftUI

struct StarRatingView: View {
    let rating: Double
    let imageScale: Image.Scale = .medium
    
    private let max = 5
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...max, id: \.self) { i in
                Image(systemName: i <= Int(rating) ? "star.fill" : "star")
                    .imageScale(imageScale)
            }
            .foregroundColor(.primarySB)
        }
    }
}

#Preview("Light") {
    StarRatingView(rating: 3)
}

#Preview("Dark") {
    StarRatingView(rating: 3)
        .preferredColorScheme(.dark)
}
