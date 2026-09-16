//
//  ProfileEmployeesSuccessView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.09.2026.
//

import SwiftUI

struct ProfileEmployeesSuccessView: View {
    let employees: [Employee]
    let isOwnProfile: Bool
    let onNavigateToUserProfile: (ProfileNavigationParams) -> Void
    let onNavigateToBooking: (Employee) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(String(localized: "employees"))
                .font(.title3.bold())
                .foregroundColor(.onBackgroundSB)
                .padding(.base)

            ForEach(Array(employees.enumerated()), id: \.element.id) { index, employee in
                ProfileEmployeeRowView(
                    employee: employee,
                    isOwnProfile: isOwnProfile,
                    onNavigateToUserProfile: onNavigateToUserProfile,
                    onNavigateToBooking: onNavigateToBooking
                )

                if index < employees.count - 1 {
                    Divider()
                        .padding(.horizontal, .base)
                        .padding(.top, .m)
                        .padding(.bottom, .xxs)
                }
            }
        }
    }
}
