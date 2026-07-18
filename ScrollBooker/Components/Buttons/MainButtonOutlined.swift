//
//  MainButtonOutlined.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

struct MainButtonOutlined: View {
    var title: String
    var size: AppButtonSize = .large
    var fullWidth: Bool = false
    var onClick: () -> Void
    
    var body: some View {
        Button(action: onClick) {
            Text(title)
                .font(size.font)
                .frame(maxWidth: fullWidth ? .infinity : nil)
        }
        .padding(.vertical, size.verticalPadding)
        .padding(.horizontal, size.horizontalPadding)
        .foregroundColor(.onBackgroundSB)
        .fontWeight(.semibold)
        .overlay(
            Capsule()
                .stroke(.divider, lineWidth: 1)
        )
        .frame(maxWidth: fullWidth ? .infinity : nil)
    }
}
