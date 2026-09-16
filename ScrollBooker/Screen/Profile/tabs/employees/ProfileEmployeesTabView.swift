//
//  ProfileEmployeesTabView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.07.2026.
//

import SwiftUI

struct ProfileEmployeesTabView: View {
    let controller: ProfileController
    let businessOwnerId: Int
    let isOwnProfile: Bool
    let onNavigateToUserProfile: (ProfileNavigationParams) -> Void
    let onNavigateToBooking: (Employee) -> Void

    var body: some View {
        switch controller.employeesState {
        case .idle, .loading:
            LoadingView(maxHeight: 500)

        case .error(let message):
            ErrorView(message: message, maxHeight: 500) {
                Task { await controller.loadInitialEmployees(businessOwnerId: businessOwnerId) }
            }

        case .success(let employees):
            if employees.isEmpty {
                NoDataView(
                    title: String(localized: "employees"),
                    message: String(localized: "message_empty_employees"),
                    maxHeight: 500
                )
            } else {
                ProfileEmployeesSuccessView(
                    employees: employees,
                    isOwnProfile: isOwnProfile,
                    onNavigateToUserProfile: onNavigateToUserProfile,
                    onNavigateToBooking: onNavigateToBooking
                )
            }
        }
    }
}
