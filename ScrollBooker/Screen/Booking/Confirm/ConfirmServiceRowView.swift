//
//  ConfirmServiceRowView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.07.2026.
//

import SwiftUI

struct ConfirmServiceRowView: View {
    let item: SelectedBookingItem
    let offering: ProductOffering?
    
    private var hasDiscount: Bool {
        guard let offering else { return false }
        return offering.discount > 0
    }
    
    private var formattedPriceWithDiscount: String {
        guard let offering else { return "N/A" }
        return String(format: "%.2f RON", NSDecimalNumber(decimal: offering.priceWithDiscount).doubleValue)
    }
    
    private var formattedOriginalPrice: String {
        guard let offering else { return "" }
        return String(format: "%.0f", NSDecimalNumber(decimal: offering.price).doubleValue)
    }
    
    private var formattedDiscountPercentage: String {
        guard let offering else { return "" }
        return String(format: "(-%.0f%%)", NSDecimalNumber(decimal: offering.discount).doubleValue)
    }
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.productName)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.onBackgroundSB)
                
                Text("\(item.variantDuration) min")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()

            HStack(spacing: 8) {
                Text(formattedPriceWithDiscount)
                    .font(.system(size: 17))
                    .fontWeight(.semibold)
                    .foregroundColor(.onBackgroundSB)
                
                if hasDiscount {
                    Text(formattedOriginalPrice)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .strikethrough(true, color: .gray)
                    
                    Text(formattedDiscountPercentage)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.red)
                }
            }
        }
        .padding(.all, .base)
    }
}
