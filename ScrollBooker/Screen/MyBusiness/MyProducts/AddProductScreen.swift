//
//  AddProductScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 30.07.2026.
//

import SwiftUI

struct AddProductScreen: View {
    @State var viewModel: AddProductViewModel
    let onBack: () -> Void
    let onCreated: () -> Void

    @State private var showErrors = false

    var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: "Adaugă Produs", onBack: onBack)

            ScrollView {
                ProductFormView(
                    form: viewModel.form,
                    showErrors: showErrors,
                    onAddVariant: { viewModel.form.addVariant($0) },
                    onUpdateVariant: { viewModel.form.updateVariant($0) },
                    onDeleteVariant: { viewModel.form.removeVariant(id: $0.id) }
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
                title: "Creează Produs",
                isLoading: viewModel.isSaving
            ) {
                showErrors = true
                Task {
                    if await viewModel.createProduct() {
                        onCreated()
                    }
                }
            }
            .padding(.base)
        }
        .task {
            await viewModel.loadInitialData()
        }
    }
}
