//
//  StartRatingView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 29.08.2025.
//

import SwiftUI

struct StartRatingView: View {
    let rating: Int
    private let max = 5
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...max, id: \.self) { i in
                Image(systemName: i <= rating ? "star.fill" : "star")
                    .imageScale(.medium)
            }
            .foregroundColor(.primarySB)
        }
    }
}

#Preview("Light") {
    StartRatingView(rating: 3)
}

#Preview("Dark") {
    StartRatingView(rating: 3)
    
}
