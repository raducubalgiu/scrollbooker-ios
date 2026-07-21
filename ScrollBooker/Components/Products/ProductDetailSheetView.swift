//
//  ProductDetailSheetView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.07.2026.
//

import SwiftUI

struct ProductDetailSheetView: View {
    let product: Product
    var onVariantSelected: (ProductVariant) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text(product.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.onBackgroundSB)
                
                if let description = product.description, !description.isEmpty {
                    Text(description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.top, 4)
                }
                
                Text("Selectează opțiunea dorită:")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                    .padding(.top, 12)
            }
            .padding(.horizontal, 24)
            .padding(.top, 28)
            .padding(.bottom, 16)
            
            Divider()
                .background(Color.gray.opacity(0.3))
            
            ScrollView {
                VStack(spacing: 14) {
                    ForEach(product.variants) { variant in
                        Button(action: { onVariantSelected(variant) }) {
                            HStack(alignment: .center, spacing: 16) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(variant.name)
                                        .font(.body)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.onBackgroundSB)
                                        .multilineTextAlignment(.leading)
                                    
                                    HStack(spacing: 4) {
                                        Image(systemName: "clock")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        Text("\(variant.duration) min")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                Spacer()
                                
                                let price = variant.offerings.first?.priceWithDiscount ?? 0
                                Text(String(format: "%.2f RON", NSDecimalNumber(decimal: price).doubleValue))
                                    .font(.body)
                                    .fontWeight(.bold)
                                    .foregroundColor(.accentColor)
                                
                                Image(systemName: "chevron.right")
                                    .font(.footnote)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.gray.opacity(0.7))
                            }
                            .padding(.all, 16)
                            .background(Color(uiColor: .secondarySystemBackground))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 24)
                    }
                }
                .padding(.vertical, 16)
            }
        }
    }
}
