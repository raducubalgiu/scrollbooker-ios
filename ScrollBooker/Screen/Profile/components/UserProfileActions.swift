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
    var isFollow: Bool
    var isFollowEnabled: Bool

    var onFollow: () -> Void
    var onNavigateToBooking: () -> Void
    var onOpenContactSheet: () -> Void

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
                } else {
                    ProfileActionButton(
                        title: String(localized: "contactUs"),
                        backgroundColor: Color.primarySB,
                        foregroundColor: Color.onPrimarySB,
                        onClick: onOpenContactSheet
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
