//
//  BusinessTeamTabView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 02.09.2025.
//

import SwiftUI

struct BusinessEmployeesTabView: View {
    let employees: [BusinessProfileEmployee]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(employees) { employee in
                    BusinessEmployeeCard(employee: employee)
                }
            }
            .padding(.horizontal, 16)
        }
    }
}
