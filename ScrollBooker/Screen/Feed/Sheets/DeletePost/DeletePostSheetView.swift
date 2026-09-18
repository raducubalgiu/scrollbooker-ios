//
//  DeletePostSheetView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.09.2026.
//

import SwiftUI

struct DeletePostSheetView: View {
    let postId: Int
    var viewModel: DeletePostViewModel
    var onDeleted: (Int) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var measuredHeight: CGFloat = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SheetHeaderView(
                onDismiss: { dismiss() },
                title: String(localized: "deletePost")
            )

            Text(String(localized: "areYouSureYouWantDeletePost"))
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
                    isLoading: viewModel.isDeleting,
                    bgColor: .errorSB,
                    onClick: {
                        Task {
                            if await viewModel.deletePost(id: postId) {
                                onDeleted(postId)
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
                .disabled(viewModel.isDeleting)
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
