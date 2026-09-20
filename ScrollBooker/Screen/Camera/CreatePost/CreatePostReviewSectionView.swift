//
//  CreatePostReviewSectionView.swift
//  ScrollBooker
//

import SwiftUI

struct CreatePostReviewSectionView: View {
    let rating: Int
    let review: String
    var onRatingChange: (Int) -> Void
    var onReviewChange: (String) -> Void

    private var ratingLabel: String {
        switch rating {
        case 1: String(localized: "rating_1")
        case 2: String(localized: "rating_2")
        case 3: String(localized: "rating_3")
        case 4: String(localized: "rating_4")
        case 5: String(localized: "rating_5")
        default: ""
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppSize.base.rawValue) {
            AddReviewRatingView(
                selectedRating: rating > 0 ? rating : nil,
                onRatingClick: onRatingChange,
                ratingLabel: ratingLabel
            )

            TextField(
                String(localized: "shareSomeDetailsAboutYourExperience"),
                text: Binding(
                    get: { review },
                    set: { onReviewChange($0) }
                ),
                axis: .vertical
            )
            .font(.subheadline)
            .lineLimit(4, reservesSpace: true)
            .padding(AppSize.s.rawValue)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.surfaceSB)
            )
        }
    }
}
