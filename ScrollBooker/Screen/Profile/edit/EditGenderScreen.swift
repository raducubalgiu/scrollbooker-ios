//
//  EditGenderScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 26.08.2025.
//

import SwiftUI

struct EditGenderScreen: View {
    let viewModel: MyProfileViewModel
    var onBack: () -> Void
    
    @State private var selectedGender: GenderTypeEnum = .other
    private let genders = GenderTypeEnum.allCases
    
    private var isButtonDisabled: Bool {
        let initialGenderKey = viewModel.profileController.uiState.data?.gender ?? ""
        let isNotChanged = selectedGender.rawValue == initialGenderKey
        return isNotChanged || viewModel.isLoading
    }
    
    var body: some View {
        FormLayout(
            headline: String(localized: "chooseYourGender", defaultValue: "Alege genul tău"),
            subHeadline: String(localized: "genderLabelDescription", defaultValue: "Aceste informații ne ajută să îți personalizăm experiența în aplicație."),
            enableBottomButton: true,
            enableBack: true,
            buttonTitle: String(localized: "save"),
            isDisabled: isButtonDisabled,
            isLoading: viewModel.isLoading,
            onBack: onBack,
            onClick: {
                Task { await viewModel.updateGender(genderEnum: selectedGender) }
            }
        ) {
            genderRadioList
        }
        .onAppear {
            let currentGenderKey = viewModel.profileController.uiState.data?.gender ?? ""
            if let matchedEnum = GenderTypeEnum.fromKey(currentGenderKey) {
                selectedGender = matchedEnum
            }
        }
        .onChange(of: viewModel.isSaved) { _, saved in
            if saved {
                onBack()
                viewModel.isSaved = false
            }
        }
    }
    
    @ViewBuilder
    private var genderRadioList: some View {
        VStack(spacing: 0) {
            ForEach(Array(genders.enumerated()), id: \.element) { index, gender in
                InputRadio(
                    title: gender.label,
                    isSelected: gender == selectedGender,
                    onClick: { selectedGender = gender }
                )
                .disabled(viewModel.isLoading)
                
                if index < genders.count - 1 {
                    Divider()
                        .background(Color.gray.opacity(0.3))
                        .padding(.vertical, .s)
                }
            }
        }
        .cornerRadius(12)
    }
}
