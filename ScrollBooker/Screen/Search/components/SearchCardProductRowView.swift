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
                
                if !product.filters.isEmpty {
                    Text("  \u{2022}  ")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                ForEach(Array(product.filters.enumerated()), id: \.element.id) { index, filter in
                    Group {
                        switch filter.type {
                            case .options:
                                ForEach(Array(filter.subFilters.enumerated()), id: \.element.id) { subIndex, subFilter in
                                    Text(subFilter.name)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .lineLimit(1)
                                    
                                    if subIndex < filter.subFilters.count - 1 {
                                        Text(" & ")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                                
                            case .range:
                                let filterText: String = {
                                    if let min = filter.minim, filter.maxim == nil { return "> \(min)" }
                                    if filter.minim == nil, let max = filter.maxim { return "< \(max)" }
                                    return "\(filter.minim ?? 0) - \(filter.maxim ?? 0)"
                                }()
                                
                                Text("\(filterText) \(filter.unit ?? "")")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .lineLimit(1)
                        case .none:
                            EmptyView()
                        }
                    }
                    
                    if index < product.filters.count - 1 {
                        Text("  \u{2022}  ")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
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
