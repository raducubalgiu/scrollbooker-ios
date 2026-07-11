//
//  EmploymentSelectEmployeeScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 30.08.2025.
//

import SwiftUI

struct EmploymentSelectEmployeeScreen: View {
    @Bindable var viewModel: MyEmployeesViewModel
    
    let onBack: () -> Void
    let onNext: () -> Void
    
    @FocusState private var isSearchFieldFocused: Bool
    
    private var isButtonDisabled: Bool {
        viewModel.isSaving || viewModel.selectedUserForEmployment == nil
    }
    
    var body: some View {
        FormLayout(
            headline: String(localized: "selectEmployee"),
            subHeadline: String(localized: "searchEmployeeAndSelectToContinue"),
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
                SearchBarView(
                    text: $viewModel.searchTextEmployee,
                    onSubmit: { viewModel.performInstantEmployeeSearch() },
                    onClear: { viewModel.selectedUserForEmployment = nil }
                )
                
                VStack {
                    switch viewModel.searchState {
                    case .idle:
                        NoDataView(
                            title: String(localized: "users"),
                            message: String(localized: "searchEmployeeIdleMessage"),
                            systemImage: "person.badge.plus"
                        )
                        
                    case .loading:
                        LoadingView()
                        
                    case .empty:
                        NoDataView(
                            title: String(localized: "users"),
                            message: String(localized: "notFoundUsers"),
                            systemImage: "person.slash"
                        )
                        
                    case .success(let users):
                        EmploymentEmployeesListView(
                            users: users,
                            selectedUser: $viewModel.selectedUserForEmployment
                        )
                        
                    case .error(let message):
                        ErrorView(message: message) {
                            viewModel.performInstantEmployeeSearch()
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            isSearchFieldFocused = true
        }
    }
}
