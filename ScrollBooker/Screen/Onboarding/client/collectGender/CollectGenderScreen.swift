//
//  CollectUserGenderScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

struct CollectGenderScreen: View {
    @State var selected: GenderEnum = GenderEnum.other
    @State var viewModel: CollectGenderViewModel
    
    func handleCollectGender() {
        Task { await viewModel.collectGender(gender: selected) }
    }
    
    var body: some View {
        FormLayout(
            headline: String(localized: "chooseYourGender"),
            subHeadline: String(localized: "genderLabelDescription"),
            buttonTitle: String(localized: "nextStep"),
            isDisabled: viewModel.isLoading,
            isLoading: viewModel.isLoading,
            onClick: handleCollectGender,
        ) {
            ForEach(Array(GenderEnum.allCases.enumerated()), id: \.element) { index, option in
                InputRadio(
                    title: option.localized,
                    isSelected: option == selected,
                    onClick: { selected = option }
                )
                
                if index < GenderEnum.allCases.count - 1 {
                    Divider()
                }
            }
        }
    }
}

//#Preview("Light") {
//    CollectClientGenderScreen()
//}
//
//#Preview("Dark") {
//    CollectClientGenderScreen()
//        .preferredColorScheme(.dark)
//}
