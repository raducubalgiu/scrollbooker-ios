//
//  AppointmentDetailsScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.08.2025.
//

import SwiftUI

struct AppointmentDetailsScreen: View {
    @Bindable var viewModel: AppointmentDetailsViewModel
    @State private var activeSheet: AppointmentDetailsSheet? = nil
    @State private var pendingSheetAction: (() -> Void)?
    var onNavigateToCamera: (CameraParams) -> Void
    var onNavigateToBooking: (BookingNavigationParams) -> Void
    var onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(
                title: String(localized: "bookingDetails"),
                onBack: onBack
            )
            
            VStack {
                switch viewModel.viewState {
                case .idle, .loading:
                    LoadingView()
                    
                case .error:
                    ErrorView(message: String(localized: "message_error_something_went_wrong")) {
                        Task { await viewModel.refresh() }
                    }
                    
                case .success(let appointment):
                    AppointmentDetailsSuccessView(
                        appointment: appointment,
                        isSaving: viewModel.isSaving,
                        isFinished: viewModel.isFinished,
                        onOpenCancelSheet: {
                            self.activeSheet = .cancelAppointment
                        },
                        onOpenReviewSheet: { rating in
                            self.activeSheet = .writeReview(rating: rating)
                        },
                        onOpenReviewOptions: { review in
                            self.activeSheet = .reviewOptions(review: review)
                        },
                        onNavigateToCamera: onNavigateToCamera,
                        onNavigateToBooking: onNavigateToBooking,
                        onRefresh: {
                            await viewModel.refresh()
                        }
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.backgroundSB)
        .navigationBarHidden(true)
        .task {
            await viewModel.loadAppointment()
        }
        .sheet(item: $activeSheet, onDismiss: {
            pendingSheetAction?()
            pendingSheetAction = nil
        }) { sheetType in
            if let appointmentData = viewModel.viewState.data {
                switch sheetType {
                case .writeReview(let rating):
                    WriteReviewSheetView(rating: rating) { selectedRating, message in
                        guard let userId = appointmentData.user.id else { return }
                        let productId = appointmentData.products.first?.id ?? 0

                        await viewModel.createReview(
                            review: message,
                            rating: selectedRating,
                            userId: userId,
                            productId: productId
                        )
                    }

                case .cancelAppointment:
                    CancelAppointmentSheetView { finalReason in
                        await viewModel.cancelCurrentAppointment(reason: finalReason)
                    }

                case .reviewOptions(let review):
                    WrittenReviewOptionsSheetView(
                        onEditReview: { pendingSheetAction = { activeSheet = .editReview(review: review) } },
                        onDeleteReview: { pendingSheetAction = { activeSheet = .deleteReviewConfirm(reviewId: review.id) } }
                    )

                case .editReview(let review):
                    WriteReviewSheetView(
                        rating: review.rating,
                        review: review.review ?? "",
                        isEditMode: true
                    ) { selectedRating, message in
                        await viewModel.updateReview(reviewId: review.id, review: message, rating: selectedRating)
                    }

                case .deleteReviewConfirm(let reviewId):
                    DeleteReviewSheetView(reviewId: reviewId, viewModel: viewModel, onDeleted: {})
                }
            }
        }
    }
}

