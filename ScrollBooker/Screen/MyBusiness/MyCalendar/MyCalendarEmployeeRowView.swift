//
//  MyCalendarEmployeeRowView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.09.2026.
//

import SwiftUI

struct MyCalendarEmployeeRowView: View {
    let employee: Employee
    let isSelected: Bool
    let hasAvailability: Bool?
    var onSelect: () -> Void

    private var availabilityText: String? {
        guard let hasAvailability else { return nil }
        return hasAvailability ? String(localized: "employeeHasAvailability") : String(localized: "employeeFullyBooked")
    }

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: AppSize.base.rawValue) {
                AvatarView(imageURL: employee.avatarURL, size: .m, isOpen: hasAvailability)

                VStack(alignment: .leading, spacing: 2) {
                    Text(employee.fullName)
                        .font(.subheadline.bold())
                        .foregroundColor(.onBackgroundSB)

                    Text(availabilityText ?? employee.job)
                        .font(.footnote)
                        .foregroundColor(.gray)
                }

                Spacer()

                ZStack {
                    if isSelected {
                        Circle()
                            .fill(Color.primarySB)
                            .frame(width: 22, height: 22)

                        Circle()
                            .fill(Color.backgroundSB)
                            .frame(width: 9, height: 9)
                    } else {
                        Circle()
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            .frame(width: 22, height: 22)
                    }
                }
            }
            .padding(.vertical, .s)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
