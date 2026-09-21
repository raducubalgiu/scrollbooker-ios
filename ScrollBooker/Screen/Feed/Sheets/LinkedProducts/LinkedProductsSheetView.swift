//
//  LinkedProductsSheetView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.07.2026.
//

import SwiftUI

struct LinkedProductsSheetView: View {
    let viewModel: LinkedProductsViewModel
    let post: Post
    let bookingSource: BookingSourceEnum
    var onNavigateToUserProfile: (ProfileNavigationParams) -> Void
    let onNavigateToBooking: (BookingNavigationParams) -> Void

    private var title: String {
        viewModel.isVideoReview ? String(localized: "videoReviewDetails") : ""
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()

                if viewModel.isVideoReview {
                    VideoReviewSectionView(
                        viewModel: viewModel,
                        post: post,
                        onNavigateToUserProfile: onNavigateToUserProfile,
                        onNavigateToBooking: onNavigateToBooking,
                        bookingSource: bookingSource
                    )
                } else {
                    switch viewModel.viewState {
                    case .idle, .loading:
                        LoadingView()

                    case .error:
                        ErrorView(message: String(localized: "message_error_something_went_wrong")) {
                            Task { await viewModel.loadLinkedProducts() }
                        }

                    case .success(let linkedProducts):
                        LinkedProductsSuccessView(
                            linkedProducts: linkedProducts,
                            bookingSource: bookingSource,
                            onNavigateToBooking: onNavigateToBooking
                        )
                    }
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .task {
                if viewModel.isVideoReview {
                    await viewModel.loadReviewAppointment()
                } else {
                    await viewModel.loadLinkedProducts()
                }
            }
        }
    }
}


