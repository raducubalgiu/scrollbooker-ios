//
//  MyCalendarBlockToggleButton.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import SwiftUI

struct MyCalendarBlockToggleButton: View {
    let isActive: Bool
    let isEnabled: Bool
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Image(systemName: "lock.fill")
                .font(.system(size: 16))
                .foregroundColor(isActive ? .errorSB : (isEnabled ? .onBackgroundSB : .gray.opacity(0.4)))
                .frame(width: 40, height: 40)
                .background(isActive ? Color.errorSB.opacity(0.2) : Color.surfaceSB)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
    }
}
