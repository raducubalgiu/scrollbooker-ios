//
//  CreatePostScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 27.07.2026.
//

import SwiftUI

struct CreatePostScreen: View {
    @Bindable var viewModel: CameraViewModel
    var onBack: () -> Void
    var onPostCreated: () -> Void
    var onNavigateToPreview: () -> Void
    var onNavigateToCover: () -> Void
    var onNavigateToEditProduct: (Int) -> Void

    var body: some View {
        VStack(spacing: 0) {
            HeaderView(
                title: String(localized: "createPostTitle"),
                onBack: onBack
            )

            ScrollView {
                VStack(alignment: .leading, spacing: AppSize.xl.rawValue) {
                    CreatePostHeaderView(
                        viewModel: viewModel,
                        onNavigateToPreview: onNavigateToPreview,
                        onNavigateToCover: onNavigateToCover
                    )

                    EditPostContentView(
                        isVideoReview: viewModel.isVideoReview,
                        rating: viewModel.rating,
                        review: viewModel.review,
                        onRatingChange: { viewModel.setRating($0) },
                        onReviewChange: { viewModel.setReview($0) },
                        serviceDomainOptions: viewModel.serviceDomainOptions,
                        selectedServiceDomainId: viewModel.selectedServiceDomainId,
                        onSelectServiceDomain: { viewModel.toggleSelectedServiceDomain($0) },
                        linkedProducts: viewModel.linkedProducts,
                        userProductsViewState: viewModel.userProductsViewState,
                        onConfirmLinkedProductsSelection: { viewModel.setLinkedProducts($0) },
                        onEditLinkedProduct: { onNavigateToEditProduct($0.id) },
                        onRemoveLinkedProduct: { viewModel.removeLinkedProduct($0) }
                    )

                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundColor(.errorSB)
                    }
                }
                .padding(.top, .base)
                .padding(.horizontal, .base)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .navigationBarHidden(true)
        .background(Color.backgroundSB)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            VStack(spacing: 0) {
                Divider()

                MainButton(
                    title: String(localized: "postNow"),
                    isDisabled: !viewModel.canSubmitPost,
                    isLoading: viewModel.isSaving,
                    onClick: {
                        Task {
                            if await viewModel.createPost() {
                                onPostCreated()
                            }
                        }
                    }
                )
                .padding(.base)
            }
            .background(Color.backgroundSB)
        }
    }
}
