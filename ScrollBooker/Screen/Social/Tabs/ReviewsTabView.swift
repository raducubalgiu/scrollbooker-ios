//
//  ReviewsTabView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 28.08.2025.
//

import SwiftUI

struct ReviewsTabView: View {
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(userReviews) { review in
                        ReviewCardView(review: review)
                            .padding(.horizontal)
                    }
                }
            }
        }
    }
}

#Preview("Light") {
    ReviewsTabView()
}

#Preview("Dark") {
    ReviewsTabView()
        .preferredColorScheme(.dark)
}
