//
//  MainButtonOutlined.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

struct MainButtonOutlined: View {
    var title: String
    var onClick: () -> Void
    
    var body: some View {
        Button(title) {
            onClick()
        }
        .padding(.vertical, 12.5)
        .padding(.horizontal, 25)
        .foregroundColor(.onBackgroundSB)
        .fontWeight(.semibold)
        .overlay(
            Capsule()
                .stroke(.divider, lineWidth: 1)
        )
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
