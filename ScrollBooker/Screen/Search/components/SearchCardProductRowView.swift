//
//  SearchCardProductRowView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.07.2026.
//

import SwiftUI

struct SearchCardProductRowView: View {
    let product: Product
    let onSelectProduct: (Product) -> Void
    
    var body: some View {
        let startingOffering = product.startingOffering
        let filtersSummary = product.getFiltersSummary()

        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .top, spacing: 0) {
                Text(product.name)
                    .font(.subheadline.bold())
                    .foregroundColor(.onBackgroundSB)
                    .lineLimit(2)
                
                Spacer()
                
                HStack(alignment: .center, spacing: 8) {
                    Text("\(startingOffering.priceWithDiscount.toTwoDecimals()) RON")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.onBackgroundSB)
                    
                    if startingOffering.discount > 0 {
                        HStack(alignment: .center, spacing: 8) {
                            Text(startingOffering.price.toTwoDecimals())
                                .font(.subheadline)
                                .strikethrough()
                                .foregroundColor(.gray)
                            
                            Text("(-\(startingOffering.discount.toTwoDecimals())%)")
                                .font(.subheadline)
                                .foregroundColor(.errorSB)
                                .fontWeight(.semibold)
                        }
                    }
                }
            }
            
            HStack(alignment: .center, spacing: 0) {
                Text(startingOffering.duration.formatDuration())
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                if product.type == .pack, let sessionsCount = product.sessionsCount {
                    Text("  \u{2022}  \(sessionsCount) ședințe")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                if !filtersSummary.isEmpty {
                    Text("  \u{2022}  \(filtersSummary)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.m)
        .background(Color.surfaceSB)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .onTapGesture {
            onSelectProduct(product)
        }
    }
}
