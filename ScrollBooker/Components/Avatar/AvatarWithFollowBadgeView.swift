//
//  AvatarWithFollowBadgeView.swift
//  ScrollBooker
//

import SwiftUI

struct AvatarWithFollowBadgeView: View {
    var url: URL?
    var size: AvatarView.AvatarSize = .l
    var isFollowing: Bool
    var onAvatarTap: () -> Void
    var onFollowTap: () -> Void

    var body: some View {
        ZStack(alignment: .bottom) {
            Button(action: onAvatarTap) {
                AvatarView(
                    imageURL: url,
                    size: size,
                    border: AvatarView.AvatarBorder(color: .dividerSB, width: 1)
                )
            }
            .buttonStyle(.plain)

            if !isFollowing {
                Button(action: onFollowTap) {
                    Image(systemName: "plus")
                        .font(.system(size: plusFontSize, weight: .heavy))
                        .foregroundColor(.white)
                        .frame(width: badgeDiameter, height: badgeDiameter)
                        .background(Circle().fill(Color.primarySB))
                        .overlay(Circle().stroke(Color.white, lineWidth: 1.5))
                }
                .buttonStyle(.plain)
                .offset(y: badgeDiameter * 0.4)
            }
        }
    }

    private var badgeDiameter: CGFloat {
        switch size {
        case .xs: 12
        case .s: 14
        case .m: 18
        case .l: 20
        case .xl: 24
        case .xxl: 30
        }
    }

    private var plusFontSize: CGFloat {
        switch size {
        case .xs: 7
        case .s: 8
        case .m: 10
        case .l: 11
        case .xl: 13
        case .xxl: 16
        }
    }
}
