//
//  EditProductScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.09.2026.
//

import SwiftUI

struct EditProductScreen: View {
    @State var viewModel: EditProductViewModel
    let onBack: () -> Void
    let onSaved: () -> Void
    let onVariantsChanged: () -> Void

    @State private var showErrors = false

    var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: "Editează Produs", onBack: onBack)

            switch viewModel.loadingState {
            case .idle, .loading:
                LoadingView()

            case .error(let message):
                ErrorView(message: message) {
                    Task { await viewModel.loadProduct() }
                }

            case .success:
                ScrollView {
                    ProductFormView(
                        form: viewModel.form,
                        showErrors: showErrors,
                        onAddVariant: { variant in
                            Task {
                                await viewModel.saveVariant(variant)
                                onVariantsChanged()
                            }
                        },
                        onUpdateVariant: { variant in
                            Task {
                                await viewModel.saveVariant(variant)
                                onVariantsChanged()
                            }
                        },
                        onDeleteVariant: { variant in
                            Task {
                                await viewModel.deleteVariant(variant)
                                onVariantsChanged()
                            }
                        }
                    )

                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundColor(.errorSB)
                            .padding(.horizontal, .base)
                            .padding(.bottom, .base)
                    }
                }

                Divider()

                MainButton(
                    title: String(localized: "save"),
                    isLoading: viewModel.isSaving
                ) {
                    showErrors = true
                    Task {
                        if await viewModel.updateBaseInfo() {
                            onSaved()
                        }
                    }
                }
                .padding(.base)
            }
        }
        .task {
            await viewModel.loadProduct()
        }
    }
}
