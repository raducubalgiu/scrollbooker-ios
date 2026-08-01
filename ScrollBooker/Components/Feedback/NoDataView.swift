//
//  EmptyView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

import SwiftUI

struct NoDataView: View {
    let title: String
    let message: String
    var maxHeight: CGFloat = .infinity
    var systemImage: String = "tray"
    
    var body: some View {
        ContentUnavailableView {
            Label(
                title,
                systemImage: systemImage
            )
            .foregroundColor(.onBackgroundSB)
        } description: {
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: maxHeight)
    }
}
