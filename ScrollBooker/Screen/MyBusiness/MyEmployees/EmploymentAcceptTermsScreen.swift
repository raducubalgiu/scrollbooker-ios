//
//  EmploymentAcceptTermsScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 30.08.2025.
//

import SwiftUI

struct EmploymentAcceptTermsScreen: View {
    let viewModel: MyEmployeesViewModel
    let onBack: () -> Void
    let onNext: () -> Void
    
    var body: some View {
        FormLayout(
            headline: String(localized: "acceptTerms"),
            subHeadline: String(localized: "acceptTermsForFinishingEmployeeOnboarding"),
            enableBottomButton: true,
            enableBack: true,
            buttonTitle: String(localized: "send"),
            isDisabled: viewModel.isSaving,
            isLoading: viewModel.isSaving,
            onBack: onBack,
            onClick: {
//                Task {
//                    let result = await viewModel.createEmploymentRequest()
//                    switch result {
//                    case .success:
//                        onNext()
//                    case .failure:
//                        break
//                    }
//                }
            }
        ) {
            VStack(alignment: .leading, spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Some Text")
                        Text("Some Text")
                        Text("Some Text")
                        Text("Some Text")
                        Text("Some Text")
                        Text("Some Text")
                        Text("Some Text")
                        Text("Some Text")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                }
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.surfaceSB)
                )
                
                // Textul de confirmare a termenilor de dedesubt
                Text(String(localized: "acceptTermsAndConditions"))
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.top, .m)
            }
        }
    }
}
