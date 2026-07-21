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
    var onClick: (() -> Void)? = nil
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack(alignment: .bottom) {
            AvatarView(
                imageURL: url,
                size: size,
                border: AvatarView.AvatarBorder(color: .dividerSB, width: 1)
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
            onClick?()
        }
    }
    
    // MARK: - Configurații fixe per dimensiune (Calibrare exactă de Design)
    
    private var starFontSize: CGFloat {
        switch size {
        case .xs: 10
        case .s:  11
        case .m:  12
        case .l:  13  
        case .xl, .xxl: 15
        }
    }
    
    private var textFontSize: CGFloat {
        switch size {
        case .xs: 10
        case .s:  11
        case .m:  12
        case .l:  13
        case .xl, .xxl: 15
        }
    }
    
    private var horizontalPadding: CGFloat {
        switch size {
        case .xs, .s: 3
        case .m, .l:  5
        case .xl, .xxl: 6
        }
    }
    
    private var verticalPadding: CGFloat {
        switch size {
        case .xs, .s: 3
        case .m, .l:  4
        case .xl, .xxl: 5
        }
    }
    
    private var dynamicBottomPadding: CGFloat {
        switch size {
        case .xs: 4
        case .s:  6
        case .m:  8
        case .l:  11
        case .xl: 13
        case .xxl: 15
        }
    }
    
    private var dynamicOffset: CGFloat {
        switch size {
        case .xs, .s: 2
        case .m:  3
        case .l:  4
        case .xl: 5
        case .xxl: 6
        }
    }
    
    // MARK: - Resolvers
    
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
