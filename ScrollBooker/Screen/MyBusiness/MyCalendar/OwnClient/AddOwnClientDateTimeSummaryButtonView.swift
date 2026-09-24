//
//  AddOwnClientDateTimeSummaryButtonView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.09.2026.
//

import SwiftUI

struct AddOwnClientDateTimeSummaryButtonView: View {
    let value: String?
    var isEnabled: Bool = true
    var onClick: () -> Void

    var body: some View {
        Button(action: onClick) {
            HStack {
                Text(value ?? String(localized: isEnabled ? "selectDateAndTime" : "selectServicesFirst"))
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(value != nil ? .onSurfaceSB : .onSurfaceSB.opacity(0.5))

                Spacer()

                Image(systemName: "calendar")
                    .foregroundColor(.onSurfaceSB.opacity(isEnabled ? 0.6 : 0.3))
            }
            .padding(18)
            .background(Color.surfaceSB)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.dividerSB, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
    }
}
