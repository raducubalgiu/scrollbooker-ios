//
//  EmployeesTab.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

import SwiftUI

public struct EmployeesTab: View {
    let viewModel: MyEmployeesViewModel
    
    private var uiState: UiState<[Employee]> {
        viewModel.employeesUiState
    }
    
    private var employees: [Employee] {
        uiState.data
    }
    
    private var isLoading: Bool {
        uiState.isLoading
    }
    
    private var errorMessage: String? {
        uiState.errorMessage
    }
    
    public var body: some View {
        VStack {
            if isLoading && employees.isEmpty {
                LoadingView()
            } else if let errorMessage {
                ErrorView(message: errorMessage) {
                    Task { await viewModel.getEmployeesByOwner() }
                }
            } else if employees.isEmpty {
                NoDataView(
                    title: String(localized: "employees"),
                    message: String(localized: "notFoundEmployees"),
                    systemImage: "person.2"
                )
            } else {
                EmployeesListView(
                    employees: employees,
                    onDismissEmployee: { employee in }
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task {
            await viewModel.getEmployeesByOwner()
        }
    }
}
