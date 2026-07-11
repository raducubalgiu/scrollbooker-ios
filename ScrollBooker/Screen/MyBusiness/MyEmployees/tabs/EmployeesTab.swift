//
//  EmployeesTab.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

import SwiftUI

public struct EmployeesTab: View {
    let viewModel: MyEmployeesViewModel
    
    public var body: some View {
        VStack {
            switch viewModel.employeesState {
            case .idle, .loading:
                LoadingView()
                
            case .error(let message):
                ErrorView(message: message) {
                    Task { await viewModel.getEmployeesByOwner() }
                }
                
            case .empty:
                NoDataView(
                    title: String(localized: "employees"),
                    message: String(localized: "notFoundEmployees"),
                    systemImage: "person.2"
                )
                
            case .success(let employees):
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
