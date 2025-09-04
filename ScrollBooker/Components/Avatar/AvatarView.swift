//
//  Avatar.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.08.2025.
//

import SwiftUI

struct AvatarView: View {
    enum AvatarSize {
        case xs, s, m, l, xl, xxl
        
        var diameter: CGFloat {
            switch self {
            case .xs: 24
            case .s: 32
            case .m: 44
            case .l: 64
            case .xl: 88
            case .xxl: 96
            }
        }
    }
    
    struct AvatarBorder {
        var color: Color = .divider
        var width: CGFloat = 1
    }
    
    var imageURL: URL?
    var size: AvatarSize = .m
    var border: AvatarBorder? = AvatarBorder()
    var isOpen: Bool? = nil
    var placeholderImage: String = "person.fill"
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            avatarImage
                .frame(width: size.diameter, height: size.diameter)
                .clipShape(Circle())
                .overlay {
                    if let border {
                        Circle()
                            .stroke(.divider, lineWidth: border.width)
                    }
                }
                .accessibilityLabel(Text("Avatar"))
            
            if let isOpen {
                Circle()
                    .fill(isOpen ? .green : .divider)
                    .overlay(Circle().stroke(Color.white, lineWidth: 3))
                    .frame(width: badgeSize, height: badgeSize)
                    .offset(x: badgeOffset, y: badgeOffset)
                    .accessibilityHidden(true)
            }
        }
    }
    
    private var avatarImage: some View {
        Group {
            if let url = imageURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                    default:
                        placeholder
                    }
                }
            } else {
                placeholder
            }
        }
    }
    
    private var placeholder: some View {
        Image(systemName: placeholderImage)
            .resizable()
            .scaledToFit()
            .foregroundColor(.gray.opacity(0.7))
            .padding(size.diameter * 0.2)
            .background(Color.white)
    }
    
    private var badgeSize: CGFloat { max(10, size.diameter * 0.28) }
    private var badgeOffset: CGFloat { size.diameter * 0.02}
}

#Preview("Light") {
    HStack(spacing: 5) {
        AvatarView(
            size: .xs
        )
        AvatarView(
            size: .s
        )
        AvatarView(
            size: .m
        )
        AvatarView(
            size: .l
        )
        AvatarView(
            size: .xl
        )
        AvatarView(
            size: .xxl
        )
    }
    HStack(spacing: 5) {
        AvatarView(
            size: .xs,
            isOpen: true
        )
        AvatarView(
            size: .s,
            isOpen: true
        )
        AvatarView(
            size: .m,
            isOpen: true
        )
        AvatarView(
            size: .l,
            isOpen: true
        )
        AvatarView(
            size: .xl,
            isOpen: true
        )
        AvatarView(
            size: .xxl,
            isOpen: true
        )
    }
}

#Preview("Dark") {
    HStack(spacing: 5) {
        AvatarView(size: .l).preferredColorScheme(.dark)
        AvatarView(size: .xl)
        AvatarView(size: .xxl)
    }
    HStack(spacing: 5) {
        AvatarView(
            size: .xs,
            isOpen: true
        )
        AvatarView(
            size: .s,
            isOpen: true
        )
        AvatarView(
            size: .m,
            isOpen: true
        )
        AvatarView(
            size: .l,
            isOpen: true
        )
        AvatarView(
            size: .xl,
            isOpen: true
        )
        AvatarView(
            size: .xxl,
            isOpen: true
        )
    }
}
