//
//  VideoReviewCTA.swift
//  ScrollBooker
//

import SwiftUI

struct VideoReviewCTA: View {
    var onNavigateToCamera: () -> Void

    var body: some View {
        Button(action: onNavigateToCamera) {
            HStack(spacing: 12) {
                Image(systemName: "video.badge.plus")
                    .font(.system(size: 22))
                    .foregroundColor(.primarySB)

                VStack(alignment: .leading, spacing: 2) {
                    Text(String(localized: "addVideoReview"))
                        .font(.subheadline.bold())
                        .foregroundColor(.primary)

                    Text(String(localized: "addVideoReviewDescription"))
                        .font(.footnote)
                        .foregroundColor(.gray)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.footnote.bold())
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(Color.surfaceSB)
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}
