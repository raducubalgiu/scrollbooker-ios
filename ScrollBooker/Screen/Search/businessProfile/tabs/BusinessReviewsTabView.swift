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
            VStack(alignment: .leading, spacing: 10) {
                StarRatingView(rating: 4.5)
                
                HStack(spacing: 4) {
                    Text("4.5")
                        .font(.headline.bold())
                    Text("(1000)")
                        .font(.headline.bold())
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            
            ForEach(0..<5, id: \.self) { i in
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .center) {
                        HStack(spacing: 12) {
                            AvatarView(size: .l)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Raducu Balgiu")
                                    .font(.headline)
                                    .foregroundColor(.onBackgroundSB)
                                    .lineLimit(1)
                                
                                Text("@radu_balgiu")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                            }
                        }
                        
                        Spacer()
                        
                        StarRatingView(rating: 4.5)
                    }
                    
                    Text("Foarte mulțumit. Servicii excelente, recomand!")
                        .font(.body)
                        .foregroundColor(.primary)
                }
            }
        }
    }
}
