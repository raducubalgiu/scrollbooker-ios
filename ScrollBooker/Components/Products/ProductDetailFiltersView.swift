//
//  ProductDetailFiltersView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.09.2026.
//

import SwiftUI

struct ProductDetailFiltersView: View {
    let filters: [ProductFilter]

    var body: some View {
        ForEach(filters) { filter in
            VStack(alignment: .leading, spacing: AppSize.xs.rawValue) {
                Text(filter.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.onBackgroundSB)

                FlowLayout(horizontalSpacing: AppSize.s.rawValue, verticalSpacing: AppSize.s.rawValue) {
                    ForEach(filter.subFilters) { subFilter in
                        Text(subFilter.name)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.onBackgroundSB)
                            .padding(.horizontal, AppSize.m.rawValue)
                            .padding(.vertical, AppSize.s.rawValue)
                            .overlay(
                                Capsule()
                                    .stroke(Color.dividerSB, lineWidth: 1)
                            )
                    }
                }
            }
            .padding(.horizontal, .base)
        }
    }
}
