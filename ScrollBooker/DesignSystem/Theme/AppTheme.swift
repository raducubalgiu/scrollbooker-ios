//
//  AppTheme.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 12.08.2025.
//

import SwiftUI

struct AppTheme<Content: View>: View {
    let mode: ThemeMode
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        content()
            .tint(.primarySB)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background.ignoresSafeArea())
            .applyPreferredColorScheme(mode)
    }
}

extension View {
    func applyPreferredColorScheme(_ mode: ThemeMode) -> some View {
        Group {
            if let scheme = mode.prefferedColorScheme {
                self.preferredColorScheme(scheme)
            } else {
                self
            }
        }
    }
}
