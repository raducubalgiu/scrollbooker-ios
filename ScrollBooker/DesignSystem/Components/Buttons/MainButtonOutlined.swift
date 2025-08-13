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
                .stroke(.gray, lineWidth: 1)
        )
    }
}

#Preview {
    MainButtonOutlined(
        title: "Inregistreaza",
        onClick: {
            
        }
    )
}
