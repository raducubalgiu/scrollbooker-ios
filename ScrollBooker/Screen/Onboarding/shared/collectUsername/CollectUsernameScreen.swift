//
//  CollectUsernameScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

struct CollectUsernameScreen: View {
    @Bindable var viewModel: CollectUsernameViewModel

    private var isSearching: Bool {
        if case .loading = viewModel.searchState { return true }
        return false
    }

    private var trailingIcon: Image? {
        guard !viewModel.username.isEmpty, case .success(let result) = viewModel.searchState else { return nil }
        return Image(systemName: result.available ? "checkmark" : "xmark")
    }

    private var trailingIconColor: Color {
        if case .success(let result) = viewModel.searchState {
            return result.available ? .green : .errorSB
        }
        return .onSurfaceSB
    }

    var body: some View {
        FormLayout(
            headline: String(localized: "onboarding_username_title"),
            subHeadline: String(localized: "onboarding_username_description"),
            enableBottomButton: false,
            onBack: {}
        ) {
            VStack(spacing: 0) {
                Input(
                    text: $viewModel.username,
                    placeholder: String(localized: "onboarding_username_title"),
                    isLoading: isSearching,
                    leadingIcon: Image(systemName: "at"),
                    trailingIcon: trailingIcon,
                    trailingIconColor: trailingIconColor
                )
                .textInputAutocapitalization(.never)

                MainButton(
                    title: String(localized: "save"),
                    isDisabled: !viewModel.isSubmitEnabled,
                    isLoading: viewModel.isSaving,
                    onClick: { Task { await viewModel.collectUsername() } }
                )
                .padding(.top, .base)
            }
            .padding(.horizontal, .xl)
        }
    }
}
