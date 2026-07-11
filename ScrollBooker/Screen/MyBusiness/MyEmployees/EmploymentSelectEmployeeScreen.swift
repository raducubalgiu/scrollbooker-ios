//
//  EmploymentSelectEmployeeScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 30.08.2025.
//

import SwiftUI

struct EmploymentSelectEmployeeScreen: View {
    let viewModel: MyEmployeesViewModel
    let onBack: () -> Void
    let onNext: () -> Void
    
    private var isButtonDisabled: Bool {
        viewModel.isSaving
    }
    
    var body: some View {
        FormLayout(
            headline: String(localized: "selectEmployeeTitle"),
            subHeadline: String(localized: "selectEmployeeSubtitle"),
            enableBottomButton: true,
            enableBack: true,
            buttonTitle: String(localized: "next"),
            isDisabled: isButtonDisabled,
            isLoading: viewModel.isSaving,
            onBack: onBack,
            onClick: {
                onNext()
            }
        ) {
            VStack(spacing: 16) {
                Spacer()
                
                Text("Aici va veni componenta de căutare și selecție utilizator.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
