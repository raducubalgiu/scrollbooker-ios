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
    @State private var showFailureAlert = false
    
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
                            showFailureAlert = true
                        }
                }
            }
        ) {
            VStack {
                switch viewModel.consentState {
                case .idle, .loading:
                    LoadingView()
                    
                case .error:
                    ErrorView(message: String(localized: "somethingWentWrong")) {
                        Task { await viewModel.getConsentTerms() }
                    }
                    
                case .success(let consent):
                    if consent.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        NoDataView(
                            title: String(localized: "acceptTerms"),
                            message: String(localized: "termsNotFound"),
                            systemImage: "doc.plaintext.fill"
                        )
                    } else {
                        EmploymentConsentView(
                            text: consent.text,
                            isTermsAccepted: $isTermsAccepted
                        )
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .task {
            await viewModel.getConsentTerms()
        }
        .alert(String(localized: "somethingWentWrong"), isPresented: $showFailureAlert) {
            Button(String(localized: "ok"), role: .cancel) { }
        } message: {
            Text(String(localized: "failedToCreateEmploymentRequestDescription"))
        }
    }
}

