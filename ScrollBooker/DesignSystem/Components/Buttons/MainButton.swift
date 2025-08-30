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
    var isDisabled: Bool = false
    var bgColor: Color = .primarySB
    var color: Color = .onPrimarySB
    
    var body: some View {
        Button(title) {
            onClick()
        }
        .frame(maxWidth: .infinity, minHeight: 48)
        .fontWeight(.semibold)
        .padding(.vertical, 5)
        .background(
            RoundedRectangle(cornerRadius: 50)
                .fill(isDisabled ? Color.surfaceSB : bgColor)
        )
        .foregroundColor(isDisabled ? .gray : color)
        .padding(.vertical)
        .disabled(isDisabled)
        .buttonStyle(.plain)
    }
}

#Preview("Light") {
    MainButton(
        title: "Login",
        onClick: { },
        isDisabled: true
    )
    .padding()
}

#Preview("Dark") {
    MainButton(
        title: "Login",
        onClick: { },
        isDisabled: true
    )
    .padding()
    .preferredColorScheme(.dark)
}

