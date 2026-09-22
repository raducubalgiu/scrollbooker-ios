//
//  MyCalendarEmployeeDropdownView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.09.2026.
//

import SwiftUI

struct MyCalendarEmployeeDropdownView: View {
    let avatarURL: URL?
    let name: String?
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: AppSize.xs.rawValue) {
                if name != nil {
                    AvatarView(imageURL: avatarURL, size: .xs, border: nil)
                } else {
                    ZStack {
                        Circle()
                            .fill(Color.primarySB)
                            .frame(width: 24, height: 24)

                        Image(systemName: "person.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.onPrimarySB)
                    }
                }

                Text(name ?? String(localized: "selectEmployee"))
                    .foregroundColor(.onBackgroundSB)
                    .lineLimit(1)

                Spacer(minLength: 0)

                Image(systemName: "chevron.down")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, .s)
            .padding(.vertical, .xs)
            .overlay(
                Capsule().stroke(Color.dividerSB, lineWidth: 1)
            )
            .contentShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
