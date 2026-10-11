//
//  EmploymentRespondConsentScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 30.08.2025.
//

import SwiftUI

struct EmploymentRespondConsentScreen: View {
    let viewModel: InboxViewModel

    let onBack: () -> Void
    let onAcceptSuccess: () -> Void

    @State private var showFailureAlert = false

    private var isButtonDisabled: Bool {
        viewModel.consentState.data == nil || !viewModel.agreedTerms || viewModel.isSaving
    }

    var body: some View {
        FormLayout(
            headline: String(localized: "acceptTerms"),
            subHeadline: String(localized: "acceptTermsAndConditions"),
            enableBottomButton: true,
            enableBack: true,
            buttonTitle: String(localized: "acceptEmployment"),
            isDisabled: isButtonDisabled,
            isLoading: viewModel.isSaving,
            onBack: onBack,
            onClick: {
                Task {
                    let result = await viewModel.respondToRequest(status: .accepted)
                    switch result {
                    case .success:
                        onAcceptSuccess()
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
                    ErrorView(message: String(localized: "message_error_something_went_wrong")) {
                        Task { await viewModel.loadConsent() }
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
                            isTermsAccepted: Binding(
                                get: { viewModel.agreedTerms },
                                set: { _ in viewModel.setAgreed() }
                            )
                        )
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .alert(String(localized: "message_error_something_went_wrong"), isPresented: $showFailureAlert) {
            Button(String(localized: "cancel"), role: .cancel) {}
        }
    }
}
