//
//  ProfileActionsView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.08.2025.
//

import SwiftUI

struct MyProfileActionsView: View {
    var isBusinessOrEmployee: Bool = false
    
    var onNavigateToEditProfile: () -> Void
    var onNavigateToMyCalendar: () -> Void
    var onShareProfile: () -> Void
    
    var body: some View {
        HStack(spacing: 8) {
            ProfileActionButton(
                title: String(localized: "editProfile"),
                onClick: onNavigateToEditProfile
            )
            
            if isBusinessOrEmployee {
                ProfileActionButton(
                    title: "Calendar",
                    startIcon: "calendar",
                    onClick: onNavigateToMyCalendar
                )
            } else {
                ProfileActionButton(
                    title: String(localized: "shareProfile"),
                    onClick: onShareProfile
                )
            }
        }
        .padding(.horizontal)
    }
}
