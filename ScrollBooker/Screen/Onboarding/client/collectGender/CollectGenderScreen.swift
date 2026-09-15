//
//  CollectGenderScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

struct CollectGenderScreen: View {
    @Bindable var viewModel: CollectGenderViewModel
    let onBack: () -> Void

    private let genders = GenderTypeEnum.allCases

    var body: some View {
        FormLayout(
            headline: String(localized: "chooseYourGender"),
            subHeadline: String(localized: "genderLabelDescription"),
            enableBack: false,
            buttonTitle: String(localized: "nextStep"),
            isDisabled: !viewModel.isSubmitEnabled,
            isLoading: viewModel.isSaving,
            onBack: onBack,
            onClick: { Task { await viewModel.collectGender() } }
        ) {
            VStack(spacing: 0) {
                ForEach(Array(genders.enumerated()), id: \.element) { index, gender in
                    InputRadio(
                        title: gender.label,
                        isSelected: viewModel.selectedGender == gender,
                        onClick: { viewModel.selectedGender = gender }
                    )
                    .disabled(viewModel.isSaving)

                    if index < genders.count - 1 {
                        Divider()
                            .background(Color.gray.opacity(0.3))
                            .padding(.vertical, .s)
                    }
                }
            }
            .padding(.horizontal, .xl)
        }
    }
}
