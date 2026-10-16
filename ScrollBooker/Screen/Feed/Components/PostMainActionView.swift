//
//  PostMainActionView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 03.09.2025.
//

import SwiftUI

struct PostMainActionView: View {
    var isVideoReview: Bool = false
    var isDisabled: Bool = false
    var onClick: () -> Void

    private var title: String {
        isVideoReview
            ? String(localized: "bookYours")
            : String(localized: "bookNow")
    }

    var body: some View {
        Button {
            onClick()
        } label: {
            Text(title)
                .font(.footnote.bold())
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 50)
                        .fill(Color.primarySB)
                )
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .opacity(isDisabled ? 0.4 : 1)
        .disabled(isDisabled)
    }
}

