//
//  ProfileCountersView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 23.08.2025.
//

import SwiftUI

struct ProfileCountersView: View {
    var onNavigateToUserSocial: () -> Void
    
    var body: some View {
        HStack {
            ProfileCounterView(
                counter: 100,
                label: "Recenzii",
                onClick: onNavigateToUserSocial
            )
            
            VerticalDivider(height: 25)
                .padding(.horizontal, .m)
            
            ProfileCounterView(
                counter: 1500,
                label: "Urmaritori",
                onClick: onNavigateToUserSocial
            )
            
            VerticalDivider(height: 25)
                .padding(.horizontal, .m)
            
            ProfileCounterView(
                counter: 15,
                label: "Urmaresti",
                onClick: onNavigateToUserSocial
            )
        }
    }
}

#Preview("Light") {
    ProfileCountersView(onNavigateToUserSocial: {})
}

#Preview("Dark") {
    ProfileCountersView(onNavigateToUserSocial: {})
        .preferredColorScheme(.dark)
}

