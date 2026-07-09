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
            .padding(.bottom, 12)
            
            HStack(spacing: 2) {
                Image(systemName: "star.fill")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.ratingSB)
                
                Text(String(format: "%.1f", rating))
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(resolvedTextColor)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(resolvedBadgeColor)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 1)
            .offset(y: 4)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onClick()
        }
    }
    
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
