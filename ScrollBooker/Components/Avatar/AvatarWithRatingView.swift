//
//  AvatarWithRatingView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.07.2026.
//

import SwiftUI

struct AvatarWithRatingView: View {
    var url: URL?
    let rating: Double
    var size: AvatarView.AvatarSize = .l
    var badgeBackgroundColor: Color? = nil
    var onClick: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack(alignment: .bottom) {
            AvatarView(
                imageURL: url,
                size: size,
                border: AvatarView.AvatarBorder(color: .divider, width: 1)
            )
            .padding(.bottom, dynamicBottomPadding)
            
            HStack(spacing: 2) {
                Image(systemName: "star.fill")
                    .font(.system(size: starFontSize, weight: .bold))
                    .foregroundColor(.ratingSB)
                
                Text(String(format: "%.1f", rating))
                    .font(.system(size: textFontSize, weight: .bold))
                    .foregroundColor(resolvedTextColor)
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(resolvedBadgeColor)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 1)
            .offset(y: dynamicOffset)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onClick()
        }
    }
    
    private var avatarDiameter: CGFloat {
        size.diameter
    }
    
    private var starFontSize: CGFloat { max(9, avatarDiameter * 0.2) }
    private var textFontSize: CGFloat { max(10, avatarDiameter * 0.23) }
    
    private var horizontalPadding: CGFloat { max(6, avatarDiameter * 0.13) }
    private var verticalPadding: CGFloat { max(3, avatarDiameter * 0.08) }
    
    private var dynamicBottomPadding: CGFloat { max(8, avatarDiameter * 0.18) }
    private var dynamicOffset: CGFloat { max(3, avatarDiameter * 0.06) }
    
    private var resolvedBadgeColor: Color {
        if let customColor = badgeBackgroundColor {
            return customColor
        }
        return colorScheme == .dark ? Color(.secondarySystemBackground) : Color(.systemBackground)
    }
    
    private var resolvedTextColor: Color {
        if badgeBackgroundColor != nil {
            return Color(red: 28/255, green: 27/255, blue: 31/255)
        }
        return colorScheme == .dark ? .white : .black
    }
}
