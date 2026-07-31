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
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(
                title: "Adaugă Produs",
                onBack: onBack
            )
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    InputSelectView(
                        placeholder: "Categorie",
                        options: viewModel.categories,
                        selectedOption: viewModel.selectedCategoryId,
                        onValueChange: { newValue in
                            viewModel.selectedCategoryId = newValue
                        }
                    )

                    InputSelectView(
                        placeholder: "Serviciu",
                        options: viewModel.filteredServices,
                        selectedOption: viewModel.selectedServiceId,
                        onValueChange: { newValue in
                            viewModel.selectedServiceId = newValue
                        }
                    )
                    
                    Input(
                        label: "Nume",
                        text: $viewModel.name,
                        placeholder: "Adaugă numele produsului",
                    )
                    
                    Input(
                        label: "Descriere",
                        text: $viewModel.description,
                        placeholder: "Adauga o descriere"
                    )
                }
                .padding()
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                MainButton(
                    title: "Salveaza",
                    onClick: {
                        // Logica de salvare
                    }
                )
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 8)
                .background(
                    Color.backgroundSB
                        .ignoresSafeArea(edges: .bottom)
                )
            }
        }
    }
}




