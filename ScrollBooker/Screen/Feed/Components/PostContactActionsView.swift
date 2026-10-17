//
//  PostContactActionsView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.10.2026.
//

import SwiftUI

struct PostContactActionsView: View {
    var onContact: () -> Void
    var onOpenServices: () -> Void

    var body: some View {
        HStack(spacing: AppSize.s.rawValue) {
            Button(action: onContact) {
                Text(String(localized: "contactUs"))
                    .font(.footnote.bold())
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 50)
                            .fill(Color.primarySB)
                    )
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            Button(action: onOpenServices) {
                Text(String(localized: "servicesAndPrices"))
                    .font(.footnote.bold())
                    .foregroundColor(.black)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 50)
                            .fill(Color.white.opacity(0.9))
                    )
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
    }
}
