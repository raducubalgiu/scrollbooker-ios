//
//  MainButton.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

struct MainButton: View {
    var title: String
    var onClick: () -> Void
    
    var body: some View {
        Button(title) {
            onClick()
        }
        .frame(maxWidth: .infinity, minHeight: 48)
        .fontWeight(.semibold)
        .padding(.vertical, 5)
        .background(
            RoundedRectangle(cornerRadius: 50)
                .fill(Color.primarySB)
        )
        .foregroundColor(.onPrimary)
        .padding(.vertical)
    }
}

#Preview {
    MainButton(
        title: "Login",
        onClick: { }
    )
    .padding()
}
