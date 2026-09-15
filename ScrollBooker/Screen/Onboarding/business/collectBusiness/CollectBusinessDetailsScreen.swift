//
//  CollectBusinessDetailsScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

struct CollectBusinessDetailsScreen: View {
    @Bindable var viewModel: CollectBusinessViewModel
    let onBack: () -> Void
    let onNext: () -> Void

    var body: some View {
        FormLayout(
            headline: String(localized: "onboarding_business_details_title"),
            subHeadline: String(localized: "onboarding_business_details_description"),
            enableBack: true,
            buttonTitle: String(localized: "nextStep"),
            isDisabled: !viewModel.isDetailsStepValid,
            onBack: onBack,
            onClick: onNext
        ) {
            VStack(alignment: .leading) {
                InputEdit(
                    text: $viewModel.businessName,
                    placeholder: String(localized: "yourBusinessName"),
                    label: "\(String(localized: "name"))*",
                    isError: viewModel.nameErrorMessage != nil,
                    errorMessage: viewModel.nameErrorMessage ?? "",
                    onClear: { viewModel.businessName = "" },
                    maxLength: 35
                )
                .padding(.bottom, .xl)

                Textarea(
                    text: $viewModel.businessDescription,
                    placeholder: String(localized: "addDescription"),
                    label: String(localized: "description"),
                    isError: viewModel.descriptionErrorMessage != nil,
                    errorMessage: viewModel.descriptionErrorMessage ?? "",
                    maxLength: 255
                )
            }
            .padding(.horizontal, .xl)
        }
    }
}
