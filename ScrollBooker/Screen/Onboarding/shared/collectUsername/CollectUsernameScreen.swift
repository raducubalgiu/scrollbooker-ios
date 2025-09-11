//
//  CollectUserUsernameScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

struct CollectUsernameScreen: View {
    @Bindable var viewModel: CollectUsernameViewModel
    
    var body: some View {
        let trailingIcon: Image? = {
            guard !viewModel.username.isEmpty else { return nil }
            switch viewModel.isAvailable {
            case true: return Image(systemName: "checkmark")
            case false: return Image(systemName: "xmark")
            }
        }()
        
        let trailingIconColor: Color = {
            switch viewModel.isAvailable {
            case true: return Color.green
            case false: return Color.errorSB
            }
        }()
        
        FormLayout(
            headline: String(localized: "username"),
            subHeadline: String(localized: "chooseUsernameDescription"),
            enableBottomButton: false,
            buttonTitle: "",
        ) {
            VStack(spacing: 0) {
                Input(
                    text: $viewModel.username,
                    placeholder: String(localized: "username"),
                    isLoading: viewModel.isLoading,
                    leadingIcon: Image(systemName: "at"),
                    trailingIcon: trailingIcon,
                    trailingIconColor: trailingIconColor
                )
                .onChange(of: viewModel.username) { _, newValue in
                    Task { await viewModel.onUsernameChanged(newValue) }
                }
                
                MainButton(
                    title: String(localized: "save"),
                    onClick: { Task { await viewModel.collectUsername() }},
                    isDisabled: viewModel.username.isEmpty || !viewModel.isAvailable || viewModel.isLoading,
                    isLoading: viewModel.isLoading
                )
            }
        }
    }
}

//#Preview("Light") {
//    CollectUsernameScreen()
//}
//
//#Preview("Dark") {
//    CollectUsernameScreen()
//        .preferredColorScheme(.dark)
//}

