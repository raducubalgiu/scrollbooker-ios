//
//  ReviewsSheetView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.07.2026.
//

import SwiftUI

struct ReviewsSheetView: View {
    let viewModel: ReviewsViewModel

    var body: some View {
        NavigationStack {
            ReviewsSectionView(viewModel: viewModel)
                .navigationTitle(String(localized: "reviews"))
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
