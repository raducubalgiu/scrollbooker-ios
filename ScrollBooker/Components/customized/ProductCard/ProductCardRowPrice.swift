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
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color.onBackgroundSB)
            
            if discount > 0 {
                Text("100")
                    .font(.body)
                    .strikethrough()
                    .foregroundColor(.gray)
                
                Text("(-\(discount)%)")
                    .font(.system(size: 16))
                    .foregroundColor(.errorSB)
            }
            
            Spacer()
        }
    }
}
