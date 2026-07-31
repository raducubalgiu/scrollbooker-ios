//
//  EmploymentRequestsTab.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

import SwiftUI

struct EmploymentRequestsTab: View {
    let viewModel: MyEmployeesViewModel
    let onNavigateToSearchUser: () -> Void
    
    @State private var openModal = false
    @State private var employmentRequestId: Int? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                switch viewModel.requestsState {
                case .idle, .loading:
                    LoadingView()
                    
                case .error:
                    ErrorView(message: String(localized: "somethingWentWrong")) {
                        Task { await viewModel.getUserEmploymentRequests() }
                    }
                    
                case .success(let requests):
                    if requests.isEmpty {
                        NoDataView(
                            title: String(localized: "employmentRequests"),
                            message: String(localized: "notFoundEmploymentRequests"),
                            systemImage: "briefcase"
                        )
                    } else {
                        EmploymentRequestsListView(
                            requests: requests,
                            onRequestClick: { id in
                                employmentRequestId = id
                                openModal = true
                            }
                        )
                        .animation(.default, value: requests)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(spacing: 0) {
                Divider()
                
                MainButton(
                    title: String(localized: "sendAnEmploymentRequest"),
                    isDisabled: viewModel.isSaving,
                    onClick: onNavigateToSearchUser
                )
                .padding(.horizontal, .xl)
                .padding(.vertical, 8)
            }
        }
        .task {
            await viewModel.getUserEmploymentRequests()
        }
        .alert(
            String(localized: "deleteRequest"),
            isPresented: $openModal,
            presenting: employmentRequestId
        ) { id in
            Button(
                String(localized: "delete"),
                role: .destructive
            ) {
                Task {
                    await viewModel.cancelEmploymentRequest(employmentId: id)
                }
                employmentRequestId = nil
            }
            
            Button(
                String(localized: "cancel"),
                role: .cancel
            ) {
                employmentRequestId = nil
            }
        } message: { _ in
            Text(String(localized: "areYouSureDeleteEmploymentRequest"))
        }
    }
}

