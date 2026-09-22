//
//  MyCalendarHeaderActionsView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.09.2026.
//

import SwiftUI

struct MyCalendarHeaderActionsView: View {
    let showsEmployeeDropdown: Bool
    let ownAvatarURL: URL?
    let ownFullName: String
    let selectedEmployee: Employee?
    let isBlocking: Bool
    let hasFreeSlots: Bool
    let enableBack: Bool
    let enableNext: Bool
    var onOpenEmployeeSheet: () -> Void
    var onToggleBlocking: () -> Void
    var onPreviousWeek: () -> Void
    var onNextWeek: () -> Void

    var body: some View {
        HStack(spacing: AppSize.s.rawValue) {
            Group {
                if showsEmployeeDropdown {
                    MyCalendarEmployeeDropdownView(
                        avatarURL: selectedEmployee?.avatarURL,
                        name: selectedEmployee?.fullName,
                        onTap: onOpenEmployeeSheet
                    )
                } else {
                    MyCalendarOwnIdentityChipView(
                        avatarURL: ownAvatarURL,
                        name: ownFullName
                    )
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            MyCalendarBlockToggleButton(
                isActive: isBlocking,
                isEnabled: hasFreeSlots,
                onTap: onToggleBlocking
            )

            HStack(spacing: AppSize.xs.rawValue) {
                weekArrowButton(systemName: "chevron.left", isEnabled: enableBack, action: onPreviousWeek)
                weekArrowButton(systemName: "chevron.right", isEnabled: enableNext, action: onNextWeek)
            }
        }
        .padding(.horizontal, .base)
        .padding(.top, 8)
    }

    private func weekArrowButton(systemName: String, isEnabled: Bool, action: @escaping () -> Void) -> some View {
        Button {
            if isEnabled { action() }
        } label: {
            Image(systemName: systemName)
                .font(.system(size: 14, weight: .bold))
                .frame(width: 36, height: 36)
                .foregroundColor(isEnabled ? .onBackgroundSB.opacity(0.8) : .gray.opacity(0.3))
                .background(Color.clear)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(isEnabled ? Color.gray.opacity(0.3) : Color.clear, lineWidth: 1)
                )
                .contentShape(Circle())
        }
        .disabled(!isEnabled)
    }
}
