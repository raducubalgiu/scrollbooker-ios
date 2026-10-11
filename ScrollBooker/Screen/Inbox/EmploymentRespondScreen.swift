//
//  EmploymentRespondScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 30.08.2025.
//

import SwiftUI

struct EmploymentRespondScreen: View {
    let employmentId: Int
    let viewModel: InboxViewModel

    var onBack: () -> Void
    var onNavigateToConsent: () -> Void
    var onDenySuccess: () -> Void

    @State private var showDenyAlert = false

    var body: some View {
        VStack(spacing: 0) {
            HeaderView(enableBack: true, onBack: onBack)
                .padding(.horizontal, .base)
                .padding(.top, .xs)

            Group {
                switch viewModel.employmentRequestState {
                case .idle, .loading:
                    LoadingView()

                case .error:
                    ErrorView(message: String(localized: "message_error_something_went_wrong")) {
                        Task { await viewModel.loadEmploymentRequest() }
                    }

                case .success(let request):
                    ScrollView {
                        EmploymentRespondDetailsView(employer: request.employer)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            EmploymentRespondBottomBarView(
                isSaving: viewModel.isSaving,
                onDeny: { showDenyAlert = true },
                onAccept: onNavigateToConsent
            )
        }
        .background(Color.backgroundSB)
        .task {
            viewModel.setEmploymentId(employmentId)
            await viewModel.loadEmploymentRequest()
            await viewModel.loadConsent()
        }
        .alert(
            String(localized: "denyEmploymentRequest"),
            isPresented: $showDenyAlert
        ) {
            Button(String(localized: "deny"), role: .destructive) {
                Task {
                    let result = await viewModel.respondToRequest(status: .denied)
                    if case .success = result {
                        onDenySuccess()
                    }
                }
            }
            Button(String(localized: "cancel"), role: .cancel) {}
        } message: {
            Text(String(localized: "areYouSureDenyEmployment"))
        }
    }
}
