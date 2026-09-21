//
//  SearchSheetActions.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 19.07.2026.
//

import SwiftUI

struct SearchSheetActions: View {
    var onClear: () -> Void
    var onConfirm: () -> Void
    var isClearEnabled: Bool = true
    var isConfirmEnabled: Bool = true
    var clearActionText: String = String(localized: "delete")
    var primaryActionText: String = String(localized: "search")

    var body: some View {
        HStack(spacing: AppSize.base.rawValue) {
            Button(action: onClear) {
                Text(clearActionText)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(isClearEnabled ? .onBackgroundSB : .gray)
            }
            .disabled(!isClearEnabled)

            Spacer()

            SheetActionButton(
                title: primaryActionText,
                style: .filled,
                isDisabled: !isConfirmEnabled,
                onClick: onConfirm
            )
            .frame(maxWidth: 160)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
    }
}
