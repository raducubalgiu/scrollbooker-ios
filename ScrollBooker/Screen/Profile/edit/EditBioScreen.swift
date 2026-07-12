//
//  EditBioScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 26.08.2025.
//

import SwiftUI

struct EditBioScreen: View {
    let viewModel: MyProfileViewModel
    var onBack: () -> Void
    
    @State private var newBio: String = ""
    
    private let maxLength = 160
    private var errorMessage: String? {
        if newBio.count > maxLength {
            return String(localized: "bio_length_error \(maxLength)")
        }
        return nil
    }
    
    private var isInputValid: Bool {
        errorMessage == nil
    }
    
    private var isEnabled: Bool {
        let initialBio = viewModel.profileController.uiState.data?.bio ?? ""
        return newBio != initialBio && isInputValid && !viewModel.isLoading
    }
    
    var body: some View {
        VStack(spacing: 24) {
            HeaderView(
                title: String(localized: "biography"),
                onBack: onBack
            ) {
                Button {
                    Task { await viewModel.updateBio(bio: newBio) }
                } label: {
                    if viewModel.isLoading {
                        ProgressView().tint(.primarySB)
                    } else {
                        Text(String(localized: "save"))
                            .font(.subheadline.bold())
                            .foregroundColor(isEnabled ? .primarySB : .secondary)
                    }
                }
                .disabled(!isEnabled)
            }
            
            VStack {
                Textarea(
                    text: $newBio,
                    placeholder: String(localized: "writeSomethingAboutYou"),
                    label: String(localized: "aboutYou"),
                    isError: errorMessage != nil,
                    errorMessage: errorMessage ?? "",
                    isDisabled: viewModel.isLoading,
                    maxLength: maxLength
                )
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .background(Color.backgroundSB)
        .onAppear {
            if newBio.isEmpty {
                newBio = viewModel.profileController.uiState.data?.bio ?? ""
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
