//
//  CreatePostLinkedProductsSectionView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 19.09.2026.
//

import SwiftUI

struct CreatePostLinkedProductsSectionView: View {
    let linkedProducts: [Product]
    var onChangeSelection: () -> Void
    var onEdit: ((Product) -> Void)? = nil
    var onRemove: (Product) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(String(localized: "linkedProducts"))
                    .font(.title3)
                    .fontWeight(.heavy)

                Spacer()

                if !linkedProducts.isEmpty {
                    Button(String(localized: "changeLinkedProducts"), action: onChangeSelection)
                        .font(.footnote.bold())
                }
            }

            Text(String(localized: "linkedProductsSectionDescription"))
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.top, .xxs)

            if linkedProducts.isEmpty {
                PlaceholderActionBoxView(
                    description: String(localized: "linkedProductsPlaceholder"),
                    onClick: onChangeSelection
                )
                .padding(.top, .base)
            } else {
                VStack(spacing: AppSize.s.rawValue) {
                    ForEach(linkedProducts) { product in
                        LinkedProductRowView(
                            product: product,
                            onEdit: onEdit,
                            onRemove: onRemove
                        )
                    }
                }
                .padding(.top, .base)
            }
        }
    }
}
