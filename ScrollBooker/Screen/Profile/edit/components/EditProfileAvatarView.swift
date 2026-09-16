//
//  EditProfileAvatarView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.09.2026.
//

import SwiftUI

struct EditProfileAvatarView: View {
    let avatarURL: URL?
    let onClick: () -> Void

    private let diameter = AvatarView.AvatarSize.xxl.diameter

    var body: some View {
        Button(action: onClick) {
            VStack(spacing: AppSize.m.rawValue) {
                ZStack {
                    AvatarView(imageURL: avatarURL, size: .xxl, border: nil)

                    Circle()
                        .fill(Color.black.opacity(0.35))
                        .frame(width: diameter, height: diameter)

                    Image(systemName: "camera")
                        .foregroundColor(.white)
                }

                Text(String(localized: "changePhoto"))
                    .font(.subheadline.bold())
                    .foregroundColor(.primarySB)
            }
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
        .padding(.vertical, .base)
    }
}
