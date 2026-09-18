//
//  MoreOptionsSheetView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.07.2026.
//

import SwiftUI

struct MoreOptionsSheetView: View {
    let postId: Int
    var onOpenStatistics: (Int) -> Void = { _ in }
    var onNavigateToEditPost: (Int) -> Void = { _ in }
    var onOpenDeleteConfirm: (Int) -> Void = { _ in }

    @Environment(\.dismiss) private var dismiss
    @State private var measuredHeight: CGFloat = 0

    var body: some View {
        VStack(spacing: 0) {
            SheetHeaderView(
                onDismiss: { dismiss() },
                title: String(localized: "myPost")
            )

            VStack(spacing: 0) {
                ListItemView(
                    title: String(localized: "statistics"),
                    leadingIcon: "chart.bar",
                    onClick: {
                        onOpenStatistics(postId)
                        dismiss()
                    },
                    showTrailingIcon: false
                )

                ListItemView(
                    title: String(localized: "edit"),
                    leadingIcon: "pencil",
                    onClick: {
                        onNavigateToEditPost(postId)
                        dismiss()
                    },
                    showTrailingIcon: false
                )

                ListItemView(
                    title: String(localized: "delete"),
                    leadingIcon: "trash",
                    onClick: {
                        onOpenDeleteConfirm(postId)
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
