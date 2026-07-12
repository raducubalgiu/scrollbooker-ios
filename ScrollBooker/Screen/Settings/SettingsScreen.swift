//
//  SettingsScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 26.08.2025.
//

import SwiftUI

struct SettingsItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let route: Route
    let icon: String
}

private var settingsItems = [
    SettingsItem(name: "Afișare", route: .display, icon: "moon"),
    SettingsItem(name: "Raportează o problemă", route: .reportProblem, icon: "flag")
]

struct SettingsScreen: View {
    @EnvironmentObject private var session: SessionManager
    
    var onNavigate: (Route) -> Void
    var onBack: () -> Void
    
    var body: some View {
        NavigationView {
            List {
                ForEach(settingsItems) { item in
                    ListItemView(
                        title: item.name,
                        leadingIcon: item.icon,
                        onClick: { onNavigate(item.route) }
                    )
                }
                
                ListItemView(
                    title: "Deconectare",
                    leadingIcon: "rectangle.portrait.and.arrow.right",
                    onClick: { session.logout() },
                    showTrailingIcon: false,
                    color: .red
                )
            }
            .safeAreaInset(edge: .top) {
                Color.clear.frame(height: 5)
            }
            .navigationTitle("Setari")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { onBack() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.onBackgroundSB)
                    }
                }
            }
            .toolbarBackground(Color.backgroundSB, for: .navigationBar)
            .listRowSeparator(.hidden)
            .listStyle(.plain)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}
