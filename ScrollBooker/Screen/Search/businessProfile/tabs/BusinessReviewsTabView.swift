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
            
            ForEach(0..<5, id: \.self) { i in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        HStack(spacing: 16) {
                            AvatarView(size: .l)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Raducu Balgiu")
                                    .font(.headline)
                                    .foregroundColor(.onBackgroundSB)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                
                                Text("@radu_balgiu")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                        }
                        
                        Spacer()
                        
                        StarRatingView(rating: 4.5)
                    }
                    Text("Foarte mulțumit. Servicii excelente, recomand!").font(.body)
                }
                .padding(.horizontal, .base)
                .padding(.vertical, .xl)
                
                Divider()
            }
            
            MainButtonOutlined(
                title: String(localized: "seeMore"),
                fullWidth: true,
                paddingV: 17.5,
                onClick: {}
            )
            .padding()
        }
        .padding(.top)
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

