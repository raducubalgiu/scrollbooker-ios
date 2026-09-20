//
//  WrittenReviewOptionsSheetView.swift
//  ScrollBooker
//

import SwiftUI

struct WrittenReviewOptionsSheetView: View {
    var onEditReview: () -> Void
    var onDeleteReview: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var measuredHeight: CGFloat = 0

    var body: some View {
        VStack(spacing: 0) {
            SheetHeaderView(
                onDismiss: { dismiss() },
                title: String(localized: "myReview")
            )

            VStack(spacing: 0) {
                ListItemView(
                    title: String(localized: "edit"),
                    leadingIcon: "pencil",
                    onClick: {
                        onEditReview()
                        dismiss()
                    },
                    showTrailingIcon: false
                )

                ListItemView(
                    title: String(localized: "delete"),
                    leadingIcon: "trash",
                    onClick: {
                        onDeleteReview()
                        dismiss()
                    },
                    showTrailingIcon: false,
                    color: .errorSB
                )
            }
            .padding(.horizontal)
            .padding(.top, .s)
            .padding(.bottom)
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
