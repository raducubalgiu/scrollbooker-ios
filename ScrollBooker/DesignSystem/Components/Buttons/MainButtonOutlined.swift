//
//  MainButtonOutlined.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

struct MainButtonOutlined: View {
    var title: String
    var fullWidth: Bool = false
    var paddingV: CGFloat = 12.5
    var paddingH: CGFloat = 25
    var onClick: () -> Void
    
    var body: some View {
        Button(action: onClick) {
            Text(title)
                .frame(maxWidth: fullWidth ? .infinity : nil)
        }
        .padding(.vertical, paddingV)
        .padding(.horizontal, paddingH)
        .foregroundColor(.onBackgroundSB)
        .fontWeight(.semibold)
        .overlay(
            Capsule()
                .stroke(.divider, lineWidth: 1)
        )
        .frame(maxWidth: fullWidth ? .infinity : nil)
    }
}

#Preview("Light") {
    MainButtonOutlined(
        title: "Inregistreaza",
        onClick: {
            
        }
    )
}

#Preview("Dark") {
    MainButtonOutlined(
        title: "Inregistreaza",
        onClick: {
            
        }
    )
    .preferredColorScheme(.dark)
}
