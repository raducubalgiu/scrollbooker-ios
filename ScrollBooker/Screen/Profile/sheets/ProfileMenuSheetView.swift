//
//  ProfileMenuSheet.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 31.08.2025.
//

import SwiftUI

private struct ProfileMenuItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let permission: PermissionEnum
    let onClick: () -> Void
}

struct ProfileMenuSheetView: View {
    @Binding var showMenuSheet: Bool

    var onCreatePost: () -> Void
    var onNavigateToMyBusiness: () -> Void
    var onNavigateToSettings: () -> Void

    @Environment(SessionManager.self) private var session
    @State private var measuredHeight: CGFloat = 0

    private var links: [ProfileMenuItem] {
        [
            ProfileMenuItem(
                title: String(localized: "createPost"),
                icon: "camera",
                permission: .postCreate,
                onClick: {
                    showMenuSheet = false
                    onCreatePost()
                }
            ),
            ProfileMenuItem(
                title: String(localized: "myBusiness"),
                icon: "bag",
                permission: .myBusinessRoutesView,
                onClick: {
                    showMenuSheet = false
                    onNavigateToMyBusiness()
                }
            )
        ]
    }

    private var visibleLinks: [ProfileMenuItem] {
        links.filter { session.hasPermission($0.permission) }
    }

    var body: some View {
        VStack {
            ForEach(visibleLinks) { link in
                ListItemView(
                    title: link.title,
                    leadingIcon: link.icon,
                    onClick: link.onClick,
                    showTrailingIcon: false
                )
                .padding(.horizontal)
            }

            ListItemView(
                title: String(localized: "settings"),
                leadingIcon: "gearshape",
                onClick: {
                    showMenuSheet = false
                    onNavigateToSettings()
                },
                showTrailingIcon: false
            )
            .padding(.horizontal)
        }
        .padding(.top, .s)
        .padding(.bottom)
        .background(
            GeometryReader { geo in
                Color.clear
                    .onAppear { measuredHeight = geo.size.height }
                    .onChange(of: geo.size.height) { _, new in
                        measuredHeight = new
                    }
            }
        )
        .presentationDetents([.height(max(100, measuredHeight + 16))])
        .presentationContentInteraction(.resizes)
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(25)
    }
}
