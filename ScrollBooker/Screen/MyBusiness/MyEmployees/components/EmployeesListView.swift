//
//  EmployeesListView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

import SwiftUI

struct EmployeesListView: View {
    let employees: [Employee]
    let onDismissEmployee: (Employee) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(employees) { employee in
                    EmployeeCardView(
                        employee: employee,
                        onNavigateToDismissalScreen: {
                            onDismissEmployee(employee)
                        }
                    )
                }
            }
            .padding(.top, 16)
        }
    }
}
