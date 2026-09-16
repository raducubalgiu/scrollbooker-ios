//
//  ProfileEmployeeRowView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.09.2026.
//

import SwiftUI

struct ProfileEmployeeRowView: View {
    let employee: Employee
    let isOwnProfile: Bool
    let onNavigateToUserProfile: (ProfileNavigationParams) -> Void
    let onNavigateToBooking: (Employee) -> Void

    private var navigationParams: ProfileNavigationParams {
        ProfileNavigationParams(userId: employee.id, username: employee.username)
    }

    var body: some View {
        Button {
            onNavigateToUserProfile(navigationParams)
        } label: {
            HStack(spacing: AppSize.base.rawValue) {
                AvatarWithRatingView(
                    url: employee.avatarURL,
                    rating: employee.ratingsAverage,
                    size: .l
                )

                VStack(alignment: .leading, spacing: 2) {
                    Text(employee.fullName)
                        .font(.subheadline.bold())
                        .foregroundColor(.onBackgroundSB)
                        .lineLimit(1)

                    Text("\(employee.job) • \(employee.productsCount) \(String(localized: "services"))")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }

                Spacer()

                if !isOwnProfile {
                    Protected(permission: .bookButtonView) {
                        MainButtonMini(title: String(localized: "pick")) {
                            onNavigateToBooking(employee)
                        }
                    }
                }
            }
            .padding(.horizontal, .base)
            .padding(.vertical, .s)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
