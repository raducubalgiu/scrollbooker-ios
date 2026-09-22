//
//  MyCalendarOwnIdentityChipView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.09.2026.
//

import SwiftUI

struct MyCalendarOwnIdentityChipView: View {
    let avatarURL: URL?
    let name: String

    var body: some View {
        HStack(spacing: AppSize.xs.rawValue) {
            AvatarView(imageURL: avatarURL, size: .xs, border: nil)

            Text(name)
                .foregroundColor(.onBackgroundSB)
                .lineLimit(1)
        }
        .padding(.horizontal, .s)
        .padding(.vertical, .xs)
        .overlay(
            Capsule().stroke(Color.dividerSB, lineWidth: 1)
        )
    }
}
