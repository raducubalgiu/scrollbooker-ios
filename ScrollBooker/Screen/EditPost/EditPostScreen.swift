//
//  EditPostScreen.swift
//  ScrollBooker
//

import SwiftUI

struct EditPostScreen: View {
    @Bindable var viewModel: EditPostViewModel
    var onBack: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: String(localized: "editPostTitle"), onBack: onBack)

            Group {
                switch viewModel.viewState {
                case .idle, .loading:
                    LoadingView()

                case .error(let message):
                    ErrorView(message: message) {
                        Task { await viewModel.loadEditData() }
                    }

                case .success:
                    ScrollView {
                        VStack(alignment: .leading, spacing: AppSize.xl.rawValue) {
                            EditPostHeaderView(
                                coverURL: viewModel.post.mediaFiles.first?.thumbnailUrl,
                                description: viewModel.description,
                                onDescriptionChange: { viewModel.setDescription($0) }
                            )

                            EditPostContentView(
                                isVideoReview: false,
                                rating: 0,
                                review: "",
                                onRatingChange: { _ in },
                                onReviewChange: { _ in },
                                serviceDomainOptions: viewModel.serviceDomainOptions,
                                selectedServiceDomainId: viewModel.selectedServiceDomainId,
                                onSelectServiceDomain: { viewModel.toggleSelectedServiceDomain($0) },
                                linkedProducts: viewModel.linkedProducts,
                                userProductsViewState: viewModel.userProductsViewState,
                                onConfirmLinkedProductsSelection: { viewModel.setLinkedProducts($0) },
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
            }
        }
        .navigationBarHidden(true)
        .background(Color.backgroundSB)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            if viewModel.viewState.data != nil {
                VStack(spacing: 0) {
                    Divider()

                    MainButton(
                        title: String(localized: "save"),
                        isDisabled: viewModel.isSaving,
                        isLoading: viewModel.isSaving,
                        onClick: {
                            Task {
                                if await viewModel.savePost() {
                                    onBack()
                                }
                            }
                        }
                    )
                    .padding(.base)
                }
                .background(Color.backgroundSB)
            }
        }
        .task {
            await viewModel.loadEditData()
        }
    }
}
