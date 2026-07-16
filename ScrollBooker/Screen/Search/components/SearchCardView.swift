//
//  SearchCardView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.07.2026.
//

import SwiftUI

struct SearchCardView: View {
    let business: BusinessSheet
    let onNavigateToBusinessProfile: (String) -> Void
    let onSelectProduct: (Product) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SearchCardCarouselView(mediaFiles: business.mediaFiles)
            
            Spacer().frame(height: 12)
            
            SearchCardBusinessInfo(
                fullName: business.owner.fullName,
                ratingsAverage: business.owner.ratingsAverage,
                ratingsCount: business.owner.ratingsCount,
                profession: business.owner.profession,
                address: business.address,
                distance: business.distance
            )
            
            Spacer().frame(height: 12)
            
            VStack(spacing: 12) {
                ForEach(Array(business.products.enumerated()), id: \.element.id) { index, product in
                    SearchCardProductRowView(
                        product: product,
                        onSelectProduct: onSelectProduct
                    )
                }
            }
            .padding(.vertical, 8)
            
            Spacer().frame(height: 16)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, .base)
        .onTapGesture {
            onNavigateToBusinessProfile(business.owner.username)
        }
    }
}
