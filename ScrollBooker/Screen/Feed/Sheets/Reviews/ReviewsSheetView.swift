//
//  ReviewsSheetView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.07.2026.
//

import SwiftUI

struct ReviewsSheetView: View {
    @Environment(\.dismiss) private var dismiss

    let viewModel: ReviewsViewModel
    var onNavigateToVideoReview: (Post) -> Void = { _ in }

    var body: some View {
        NavigationStack {
            ReviewsSectionView(
                viewModel: viewModel,
                onNavigateToVideoReview: { post in
                    onNavigateToVideoReview(post)
                    dismiss()
                }
            )
            .navigationTitle(String(localized: "reviews"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
