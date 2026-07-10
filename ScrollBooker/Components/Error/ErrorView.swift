//
//  ErrorView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    var retryAction: () -> Void
    
    var body: some View {
        ContentUnavailableView {
            Label(
                String(localized: "errorOccurred"),
                systemImage: "wifi.exclamationmark"
            )
            .foregroundColor(.errorSB)
        } description: {
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
        } actions: {
            Button(String(localized: "retry")) {
                retryAction()
            }
            .buttonStyle(.borderedProminent)
            .tint(.primarySB)
        }
        .frame(maxHeight: .infinity)
    }
}
