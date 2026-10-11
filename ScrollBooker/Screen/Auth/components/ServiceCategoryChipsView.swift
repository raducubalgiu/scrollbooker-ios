//
//  ServiceCategoryChipsView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.10.2026.
//

import SwiftUI

struct ServiceCategoryChipsView: View {
    let categories: [String]

    var body: some View {
        LazyVGrid(
            columns: [GridItem(.adaptive(minimum: 100), spacing: AppSize.xs.rawValue)],
            alignment: .leading,
            spacing: AppSize.xs.rawValue
        ) {
            ForEach(categories, id: \.self) { category in
                Text(category)
                    .font(.footnote)
                    .fontWeight(.medium)
                    .foregroundColor(.onBackgroundSB)
                    .lineLimit(1)
                    .padding(.horizontal, AppSize.s.rawValue)
                    .padding(.vertical, AppSize.xxs.rawValue)
                    .background(Color.surfaceSB)
                    .clipShape(Capsule())
            }
        }
    }
}
