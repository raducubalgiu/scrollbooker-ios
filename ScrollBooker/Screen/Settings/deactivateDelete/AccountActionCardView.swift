//
//  AccountActionCardView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.10.2026.
//

import SwiftUI

struct AccountActionCardView: View {
    let title: String
    let description: String
    var titleColor: Color = .onBackgroundSB
    let onClick: () -> Void

    var body: some View {
        Button(action: onClick) {
            HStack(alignment: .center, spacing: AppSize.base.rawValue) {
                VStack(alignment: .leading, spacing: AppSize.xxs.rawValue) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(titleColor)

                    Text(description)
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding(.vertical, AppSize.base.rawValue)
            .padding(.horizontal, AppSize.base.rawValue)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.backgroundSB)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.dividerSB, lineWidth: 1)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
