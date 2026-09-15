//
//  Protected.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import SwiftUI

struct Protected<Content: View>: View {
    let permission: PermissionEnum
    @ViewBuilder var content: () -> Content

    @Environment(SessionManager.self) private var session

    var body: some View {
        if permission == .noProtection || session.hasPermission(permission) {
            content()
        }
    }
}
