//
//  FeedDrawerVideoReviewsToggleView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import SwiftUI

struct FeedDrawerVideoReviewsToggleView: View {
    @Binding var checked: Bool

    var body: some View {
        HStack(spacing: AppSize.s.rawValue) {
            Image(systemName: checked ? "video.fill" : "video")
                .font(.system(size: 20))
                .foregroundColor(checked ? .primarySB : Color(white: 0.67))

            VStack(alignment: .leading, spacing: AppSize.xxs.rawValue) {
                Text(String(localized: "onlyVideoReviews"))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(white: 0.88))

                Text(String(localized: "filterVideoContentAccordingToYouPreferences"))
                    .font(.footnote)
                    .foregroundColor(Color(white: 0.67))
            }

            Spacer()

            Toggle("", isOn: $checked)
                .labelsHidden()
                .tint(.primarySB)
        }
        .padding(.base)
        .background(checked ? Color.primarySB.opacity(0.12) : Color(white: 0.08))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .contentShape(Rectangle())
        .onTapGesture { checked.toggle() }
    }
}
