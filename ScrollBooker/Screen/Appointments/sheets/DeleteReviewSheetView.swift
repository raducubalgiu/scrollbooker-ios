//
//  DeleteReviewSheetView.swift
//  ScrollBooker
//

import SwiftUI

struct DeleteReviewSheetView: View {
    let reviewId: Int
    var viewModel: AppointmentDetailsViewModel
    var onDeleted: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var measuredHeight: CGFloat = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SheetHeaderView(
                onDismiss: { dismiss() },
                title: String(localized: "deleteReview")
            )

            Text(String(localized: "areYouSureYouWantDeleteReview"))
                .font(.subheadline)
                .foregroundColor(.onBackgroundSB)
                .padding(.horizontal, .base)
                .padding(.top, .base)

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundColor(.errorSB)
                    .padding(.horizontal, .base)
                    .padding(.top, .s)
            }

            VStack(spacing: AppSize.s.rawValue) {
                MainButton(
                    title: String(localized: "delete"),
                    isLoading: viewModel.isSaving,
                    bgColor: .errorSB,
                    onClick: {
                        Task {
                            if await viewModel.deleteReview(reviewId: reviewId) {
                                onDeleted()
                                dismiss()
                            }
                        }
                    }
                )

                MainButtonOutlined(
                    title: String(localized: "cancel"),
                    fullWidth: true,
                    onClick: { dismiss() }
                )
                .disabled(viewModel.isSaving)
            }
            .padding(.base)
        }
        .background(
            GeometryReader { geo in
                Color.clear
                    .onAppear { measuredHeight = geo.size.height }
                    .onChange(of: geo.size.height) { _, new in
                        measuredHeight = new
                    }
            }
        )
        .presentationDetents([.height(max(100, measuredHeight))])
        .presentationContentInteraction(.resizes)
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(25)
    }
}
