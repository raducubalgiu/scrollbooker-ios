//
//  ProductDetailBottomBarView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.09.2026.
//

import SwiftUI

struct ProductDetailBottomBarView: View {
    let buttonText: String
    let showFromPrefix: Bool
    let priceWithDiscount: Decimal
    let durationText: String
    let isEnabled: Bool
    var onAddBookingItem: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Divider()

            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: AppSize.xxs.rawValue) {
                    HStack(spacing: AppSize.xxs.rawValue) {
                        if showFromPrefix {
                            Text(String(localized: "from"))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }

                        Text("\(priceWithDiscount.toTwoDecimals()) RON")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.onBackgroundSB)
                    }

                    Text(durationText)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Spacer()

                Button(action: onAddBookingItem) {
                    Text(buttonText)
                        .font(.body)
                        .fontWeight(.semibold)
                        .padding(.vertical, AppSize.base.rawValue)
                        .padding(.horizontal, AppSize.xl.rawValue)
                }
                .foregroundColor(isEnabled ? .onPrimarySB : .gray)
                .background(
                    Capsule()
                        .fill(isEnabled ? Color.primarySB : Color.surfaceSB)
                )
                .disabled(!isEnabled)
                .buttonStyle(.plain)
            }
            .padding(.base)
        }
    }
}
