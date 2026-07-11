//
//  EmploymentAsignJobScreen\.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 30.08.2025.
//

import SwiftUI

struct EmploymentAssignJobScreen: View {
    let viewModel: MyEmployeesViewModel
    let onBack: () -> Void
    let onNext: () -> Void
    
    var body: some View {
        FormLayout(
            headline: String(localized: "assignJob"),
            subHeadline: String(localized: "chooseProfessionsFromTheList"),
            enableBottomButton: true,
            enableBack: true,
            buttonTitle: String(localized: "next"),
            isDisabled: viewModel.isSaving,
            isLoading: viewModel.isSaving,
            onBack: onBack,
            onClick: {
                onNext()
            }
        ) {
            VStack(spacing: 16) {
                Spacer()
                
                Text("Aici va veni lista sau selectorul pentru profesii.")
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
