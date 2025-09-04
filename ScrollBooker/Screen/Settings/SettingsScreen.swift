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
    SettingsItem(name: "Cont", route: .account, icon: "person"),
    SettingsItem(name: "Confidentialitate", route: .privacy, icon: "lock"),
    SettingsItem(name: "Securitate", route: .security, icon: "lock.shield"),
    SettingsItem(name: "Notificari", route: .notificationSettings, icon: "bell"),
    SettingsItem(name: "Afisare", route: .display, icon: "moon"),
    SettingsItem(name: "Raporteaza o problema", route: .reportProblem, icon: "flag"),
    SettingsItem(name: "Support", route: .support, icon: "ellipsis.message"),
    SettingsItem(name: "Termeni si conditii", route: .termsAndConditions, icon: "info.circle")
]

struct SettingsScreen: View {
    @Environment(\.dismiss) private var dismiss
    var onNavigate: (Route) -> Void
    
    var body: some View {
        NavigationView {
            List(settingsItems) { item in
                ListItemView(
                    title: item.name,
                    leadingIcon: item.icon,
                    onClick: { onNavigate(item.route)  }
                )
            }
            .safeAreaInset(edge: .top) {
                Color.clear.frame(height: 5)
            }
            .navigationTitle("Setari")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
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

#Preview("Light") {
    SettingsScreen { _ in }
}

#Preview("Dark") {
    SettingsScreen { _ in }
        .preferredColorScheme(.dark)
}
