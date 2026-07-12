//
//  EditNameScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 26.08.2025.
//

import SwiftUI

struct EditNameScreen: View {
    @Bindable var viewModel: MyProfileViewModel
    var onBack: () -> Void
    
    @State private var newFullName: String = ""
    
    private let minLength = 3
    private let maxLength = 35
    
    private var errorMessage: String? {
        if newFullName.isEmpty { return nil }
        if newFullName.count < minLength {
            return "Numele trebuie să aibă minim \(minLength) caractere"
        }
        return nil
    }
    
    private var isInputValid: Bool {
        errorMessage == nil && newFullName.count >= minLength
    }
    
    private var isEnabled: Bool {
        let initialName = viewModel.profileController.uiState.data?.fullName ?? ""
        return newFullName != initialName && isInputValid && !viewModel.isLoading
    }
    
    var body: some View {
        VStack(spacing: 24) {
            HeaderView(title: String(localized: "name"), onBack: onBack) {
                Button {
                    Task { await viewModel.updateFullName(fullname: newFullName) }
                } label: {
                    if viewModel.isLoading {
                        ProgressView().tint(.primarySB)
                    } else {
                        Text("Salvează")
                            .font(.subheadline.bold())
                            .foregroundColor(isEnabled ? .primarySB : .secondary)
                    }
                }
                .disabled(!isEnabled)
            }
            
            VStack {
                InputEdit(
                    text: $newFullName,
                    placeholder: "Numele tău",
                    label: "Nume complet",
                    isError: errorMessage != nil,
                    errorMessage: errorMessage ?? "",
                    isDisabled: viewModel.isLoading,
                    onClear: { newFullName = "" },
                    maxLength: maxLength
                )
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .background(Color.backgroundSB)
        .onAppear {
            if newFullName.isEmpty {
                newFullName = viewModel.profileController.uiState.data?.fullName ?? ""
            }
        }
        .onChange(of: viewModel.isSaved) { _, saved in
            if saved {
                onBack()
                viewModel.isSaved = false
            }
        }
    }
}
