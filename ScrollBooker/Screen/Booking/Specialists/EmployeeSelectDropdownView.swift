//
//  EmployeeSelectDropdownView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.07.2026.
//

import SwiftUI

struct EmployeeSelectDropdown: View {
    let selectedEmployee: BookingFlowUser?
    var onClick: () -> Void

    var body: some View {
        HStack(spacing: AppSize.base.rawValue) {
            HStack(spacing: AppSize.base.rawValue) {
                if let selectedEmployee {
                    AvatarView(imageURL: selectedEmployee.avatarURL, size: .m)
                } else {
                    ZStack {
                        Circle()
                            .fill(Color.primarySB)
                            .frame(width: 40, height: 40)

                        Image(systemName: "person.fill")
                            .foregroundColor(.onPrimarySB)
                    }
                }

                Text(selectedEmployee?.fullName ?? String(localized: "chooseSpecialist"))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Image(systemName: "chevron.down")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, .base)
        .padding(.vertical, .s)
        .overlay(
            Capsule().stroke(Color.dividerSB, lineWidth: 1)
        )
        .contentShape(Capsule())
        .onTapGesture(perform: onClick)
    }
}
