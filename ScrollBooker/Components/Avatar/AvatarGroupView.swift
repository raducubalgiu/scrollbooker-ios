//
//  AvatarGroupView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.09.2026.
//

import SwiftUI

struct AvatarGroupView: View {
    let avatarURLs: [URL?]
    var size: AvatarView.AvatarSize = .xs
    var overlap: CGFloat = 7
    var borderColor: Color = .backgroundSB

    var body: some View {
        HStack(spacing: -overlap) {
            ForEach(Array(avatarURLs.enumerated()), id: \.offset) { index, url in
                AvatarView(
                    imageURL: url,
                    size: size,
                    border: AvatarView.AvatarBorder(color: borderColor, width: 2)
                )
                .zIndex(Double(index))
            }
        }
    }
}
