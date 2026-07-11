//
//  EmploymentAcceptTermsScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 30.08.2025.
//

import SwiftUI

struct EmploymentAcceptTermsScreen: View {
    @Bindable var viewModel: MyEmployeesViewModel
    
    let onBack: () -> Void
    let onNext: () -> Void
    
    @State private var isTermsAccepted = false
    
    private var isButtonDisabled: Bool {
        viewModel.isSaving || !isTermsAccepted
    }
    
    var body: some View {
        FormLayout(
            headline: String(localized: "acceptTerms"),
            subHeadline: String(localized: "acceptTermsForFinishingEmployeeOnboarding"),
            enableBottomButton: true,
            enableBack: true,
            buttonTitle: String(localized: "send"),
            isDisabled: isButtonDisabled,
            isLoading: viewModel.isSaving,
            onBack: onBack,
            onClick: {
                Task {
                    let result = await viewModel.createEmploymentRequest()
                    switch result {
                        case .success:
                            onNext()
                            
                        case .failure:
                            break
                        }
                }
            }
        ) {
            VStack {
                switch viewModel.consentState {
                case .idle, .loading:
                    LoadingView()
                    
                case .error(let message):
                    ErrorView(message: message) {
                        Task { await viewModel.getConsentTerms() }
                    }
                    
                case .empty:
                    NoDataView(
                        title: String(localized: "acceptTerms"),
                        message: String(localized: "termsNotFound"),
                        systemImage: "doc.plaintext.fill"
                    )
                    
                case .success(let consent):
                    EmploymentConsentView(
                        text: consent.text,
                        isTermsAccepted: $isTermsAccepted
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .task {
            await viewModel.getConsentTerms()
        }
    }
}
