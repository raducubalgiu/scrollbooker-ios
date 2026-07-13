//
//  ProductCardRowPriceView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.07.2026.
//

import SwiftUI

struct ProductCardRowPrice: View {
    let price: Decimal
    let priceWithDiscount: Decimal
    let discount: Decimal
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Text("\(priceWithDiscount) RON")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(Color.onBackgroundSB)
            
            if discount > 0 {
                Text("100")
                    .font(.subheadline)
                    .strikethrough()
                    .foregroundColor(.gray)
                
                Text("(-\(discount)%)")
                    .font(.subheadline)
                    .foregroundColor(.errorSB)
            }
            
            Spacer()
        }
    }
}
