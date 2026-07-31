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
                
            case .error:
                ErrorView(message: String(localized: "somethingWentWrong")) {
                    Task { await viewModel.getEmployeesByOwner() }
                }
                
            case .success(let employees):
                if employees.isEmpty {
                    NoDataView(
                        title: String(localized: "employees"),
                        message: String(localized: "notFoundEmployees"),
                        systemImage: "person.2"
                    )
                } else {
                    EmployeesListView(
                        employees: employees,
                        onDismissEmployee: { employee in
                            
                        }
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task {
            await viewModel.getEmployeesByOwner()
        }
    }
}
