//
//  PostBadgesView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import SwiftUI

struct PostBadgesView: View {
    var isVideoReview: Bool
    var serviceDomain: PostServiceDomain?

    var body: some View {
        VStack(alignment: .leading, spacing: AppSize.s.rawValue) {
            if isVideoReview {
                badge(
                    text: String(localized: "videoReview"),
                    background: Color.white.opacity(0.9),
                    foreground: .black
                )
            }

            if let serviceDomain {
                badge(
                    text: serviceDomain.name,
                    background: Color.beautySB.opacity(0.8),
                    foreground: .onPrimarySB
                )
            }
        }
    }

    private func badge(text: String, background: Color, foreground: Color) -> some View {
        Text(text)
            .font(.caption.weight(.semibold))
            .foregroundColor(foreground)
            .padding(.vertical, 6)
            .padding(.horizontal, AppSize.s.rawValue)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
