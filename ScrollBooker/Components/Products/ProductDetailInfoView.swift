//
//  ProductDetailInfoView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.09.2026.
//

import SwiftUI

struct ProductDetailInfoView: View {
    let name: String
    let description: String?

    var body: some View {
        VStack(alignment: .leading, spacing: AppSize.xxs.rawValue) {
            Text(name)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.onBackgroundSB)

            if let description, !description.isEmpty {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.onBackgroundSB)
                    .lineLimit(1)
                    .truncationMode(.tail)
            } else {
                Text(String(localized: "serviceWithoutDescription"))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, .base)
    }
}
