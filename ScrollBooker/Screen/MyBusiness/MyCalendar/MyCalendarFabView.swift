//
//  MyCalendarFabView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.09.2026.
//

import SwiftUI

struct MyCalendarFabView: View {
    let isEnabled: Bool
    let domainColor: Color
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Image(systemName: "plus")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(isEnabled ? .onPrimarySB : .gray)
                .frame(width: 50, height: 50)
                .background(isEnabled ? domainColor : Color.dividerSB)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
    }
}
