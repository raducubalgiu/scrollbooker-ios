//
//  AppointmentProductPrice.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.07.2026.
//

import SwiftUI

struct AppointmentProductPrice: View {
    let name: String
    let price: Decimal
    let priceWithDiscount: Decimal
    let discount: Decimal
    let currencyName: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Text(name)
                .font(.body)
                .foregroundColor(.gray)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(alignment: .center, spacing: 5) {
                if discount > 0 {
                    Text("(-\(discount, format: .number.precision(.fractionLength(2)))%)")
                        .font(.subheadline)
                        .foregroundColor(.red)
                    
                    Text(price, format: .number.precision(.fractionLength(2)))
                        .font(.subheadline)
                        .strikethrough()
                        .foregroundColor(.gray)
                }
                
                Text("\(priceWithDiscount, format: .number.precision(.fractionLength(2))) \(currencyName)")
                    .font(.headline)
            }
            .fixedSize(horizontal: true, vertical: false)
            .layoutPriority(1)
        }
    }
}
