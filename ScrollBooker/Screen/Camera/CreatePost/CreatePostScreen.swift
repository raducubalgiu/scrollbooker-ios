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

    @State private var showLinkedProductsSheet = false

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

                    CreatePostCategorySectionView(
                        options: viewModel.serviceDomainOptions,
                        selectedOptionId: viewModel.selectedServiceDomainId,
                        onSelect: { viewModel.toggleSelectedServiceDomain($0) }
                    )

                    CreatePostLinkedProductsSectionView(
                        linkedProducts: viewModel.linkedProducts,
                        onChangeSelection: { showLinkedProductsSheet = true },
                        onEdit: { onNavigateToEditProduct($0.id) },
                        onRemove: { viewModel.removeLinkedProduct($0) }
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
        }
        .navigationBarHidden(true)
        .background(Color.backgroundSB)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            VStack(spacing: 0) {
                Divider()

                MainButton(
                    title: String(localized: "postNow"),
                    isDisabled: viewModel.isSaving,
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
        .sheet(isPresented: $showLinkedProductsSheet) {
            UserProductsSheetView(
                linkedProducts: viewModel.linkedProducts,
                userProductsViewState: viewModel.userProductsViewState,
                onConfirmSelection: { viewModel.setLinkedProducts(Array($0)) },
                onClose: { showLinkedProductsSheet = false }
            )
        }
    }
}
