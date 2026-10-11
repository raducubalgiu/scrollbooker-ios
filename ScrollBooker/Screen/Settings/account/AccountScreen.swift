//
//  AccountScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.10.2026.
//

import SwiftUI

struct AccountItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let description: String
    let route: Route
}

struct AccountScreen: View {
    var onBack: () -> Void
    var onNavigate: (Route) -> Void
    
    private let accountItems = [
        AccountItem(
            title: String(localized: "accountInfo"),
            description: String(localized: "accountInfoDescription"),
            route: .accountInfo,
        ),
        AccountItem(
            title: String(localized: "password"),
            description: String(localized: "passwordDescription"),
            route: .password,
        ),
        AccountItem(
            title: String(localized: "deactivateDeleteAccount"),
            description: String(localized: "deactivateDeleteAccountDescription"),
            route: .deactivateDeleteAccount,
        )
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(
                title: String(localized: "account"),
                onBack: onBack
            )
            
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(accountItems) { item in
                        ListItemView(
                            title: item.title,
                            description: item.description,
                            onClick: { onNavigate(item.route) }
                        )
                        
                        if item.id != accountItems.last?.id {
                            Divider()
                        }
                    }
                }
                .padding(.horizontal, .base)
            }
            
            Spacer()
        }
    }
}
