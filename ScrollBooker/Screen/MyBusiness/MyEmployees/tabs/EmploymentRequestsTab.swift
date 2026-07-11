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
                        
                    case .error(let message):
                        ErrorView(message: message) {
                            Task { await viewModel.getUserEmploymentRequests() }
                        }
                        
                    case .empty:
                        NoDataView(
                            title: String(localized: "employmentRequests"),
                            message: String(localized: "notFoundEmploymentRequests"),
                            systemImage: "briefcase"
                        )
                        
                    case .success(let requests):
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
                // Notă: Când vei decomenta acțiunea, va rula asincron la fel de curat
                // if !viewModel.isSaving {
                //     viewModel.cancelEmploymentRequest(id: id)
                // }
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
