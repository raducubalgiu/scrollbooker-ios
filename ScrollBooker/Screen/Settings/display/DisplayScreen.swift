//
//  DisplayScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 26.08.2025.
//

import SwiftUI

struct DisplayScreen: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 0) {
            Header(title: String(localized: "display"))
            
            VStack {
                InputRadio(
                    title: "System",
                    isSelected: themeManager.mode == .system,
                    onClick: { themeManager.mode = .system }
                )
                
                InputRadio(
                    title: "Light",
                    isSelected: themeManager.mode == .light,
                    onClick: { themeManager.mode = .light }
                )
                
                InputRadio(
                    title: "Dark",
                    isSelected: themeManager.mode == .dark,
                    onClick: { themeManager.mode = .dark }
                )
                
                Spacer()
            }
            .padding(.horizontal, .base)
        }
    }
}

#Preview {
    DisplayScreen()
}
