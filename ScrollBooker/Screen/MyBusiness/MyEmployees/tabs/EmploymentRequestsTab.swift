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
    
    private var uiState: UiState<[EmploymentRequest]> {
        viewModel.employmentRequestUiState
    }
    
    private var requests: [EmploymentRequest] {
        uiState.data
    }
    
    private var isLoading: Bool {
        uiState.isLoading
    }
    
    private var errorMessage: String? {
        uiState.errorMessage
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                if isLoading && requests.isEmpty {
                    LoadingView()
                } else if let errorMessage {
                    ErrorView(message: errorMessage) {
                        Task { await viewModel.getUserEmploymentRequests() }
                    }
                } else if requests.isEmpty {
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
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(spacing: 0) {
                Divider()
                
                MainButton(
                    title: String(localized: "sendAnEmploymentRequest"),
                    onClick: onNavigateToSearchUser
                )
                .padding(.horizontal, .xl)
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
                if !viewModel.isSaving {
                    viewModel.cancelEmploymentRequest(id: id)
                }
                employmentRequestId = nil
            }
            
            Button(
                String(localized: "cancel"),
                role: .cancel
            ) {
                employmentRequestId = nil
            }
        } message: {
            _ in Text(String(localized: "areYouSureDeleteEmploymentRequest"))
        }
    }
}
