//
//  FeedDrawerActionsView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import SwiftUI

struct FeedDrawerActionsView: View {
    let isClearEnabled: Bool
    let selectedCount: Int
    let onClear: () -> Void
    let onConfirm: () -> Void

    var body: some View {
        VStack(spacing: AppSize.base.rawValue) {
            Divider()
                .background(Color(white: 0.23))

            if isClearEnabled {
                Button(action: onClear) {
                    Text(String(localized: "clearFilters"))
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.errorSB)
                }
                .transition(.move(edge: .top).combined(with: .opacity))
            }

            MainButton(
                title: selectedCount > 0
                    ? "\(String(localized: "filter")) (\(selectedCount))"
                    : String(localized: "filter"),
                onClick: onConfirm
            )
        }
        .padding(.horizontal, .base)
        .padding(.bottom, .base)
        .animation(.easeInOut(duration: 0.2), value: isClearEnabled)
    }
}
