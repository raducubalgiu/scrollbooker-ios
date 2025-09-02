//
//  BusinessReviewTabView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 02.09.2025.
//

import SwiftUI

struct BusinessReviewsTabView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("reviews")
                .font(.title2.weight(.heavy))
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 10) {
                StarRatingView(rating: 4.5)
                
                HStack {
                    Text("4.5")
                        .font(.headline.bold())
                    Text("(1000)")
                        .font(.headline.bold())
                }
            }
            .padding(.leading)
            .padding(.bottom)
            
            ForEach(0..<12, id: \.self) { i in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Circle().fill(Color.gray.opacity(0.3)).frame(width: 32, height: 32)
                        Text("Client \(i+1)").font(.subheadline.weight(.semibold))
                        Spacer()
                        HStack(spacing: 2) { ForEach(0..<5, id: \.self) { _ in Image(systemName: "star.fill") } }
                            .font(.caption2)
                    }
                    Text("Foarte mulțumit. Servicii excelente, recomand!").font(.body)
                }
                .padding(16)
                Divider()
            }
        }
    }
}

#Preview("Light") {
    BusinessReviewsTabView()
        .padding(.top, 500)
}

#Preview("Dark") {
    BusinessReviewsTabView()
        .preferredColorScheme(.dark)
}

