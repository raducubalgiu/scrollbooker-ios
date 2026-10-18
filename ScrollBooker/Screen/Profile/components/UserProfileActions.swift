//
//  UserProfileActions.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 31.08.2025.
//

import SwiftUI

struct UserProfileActions: View {
    var isBusinessOrEmployee: Bool
    var instantBooking: Bool
    var contact: ContactInfo
    var isFollow: Bool
    var isFollowEnabled: Bool

    var onFollow: () -> Void
    var onNavigateToBooking: () -> Void
    var onOpenContactSheet: () -> Void

    private var contactAction: ContactActionInfo {
        ContactActionInfo(contact: contact, onOpenContactSheet: onOpenContactSheet)
    }

    var body: some View {
        HStack(spacing: 8) {
            if isBusinessOrEmployee {
                if instantBooking {
                    ProfileActionButton(
                        title: String(localized: "bookNow"),
                        backgroundColor: Color.primarySB,
                        foregroundColor: Color.onPrimarySB,
                        onClick: onNavigateToBooking
                    )
                } else if contactAction.isVisible {
                    ProfileActionButton(
                        title: contactAction.title,
                        startIcon: contactAction.isWhatsAppStyled ? "phone.bubble.left.fill" : nil,
                        backgroundColor: contactAction.isWhatsAppStyled
                            ? Color(red: 0.145, green: 0.827, blue: 0.4)
                            : Color.primarySB,
                        foregroundColor: Color.onPrimarySB,
                        onClick: contactAction.onClick
                    )
                }
            }
            
            ProfileActionButton(
                title: isFollow ? String(localized: "following") : String(localized: "follow"),
                isOutlined: isFollow,
                backgroundColor: Color.surfaceSB,
                foregroundColor: Color.onSurfaceSB,
                onClick: onFollow
            )
            .disabled(!isFollowEnabled)
        }
        .padding(.horizontal)
    }
}
