//
//  ServiceStepFooter.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import SwiftUI

struct ServiceStepFooter: View {
    var isClearEnabled: Bool = true
    var isConfirmEnabled: Bool = true
    var onClear: () -> Void
    var onConfirm: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color(.systemGray4))
                .frame(height: 0.55)

            SearchSheetActions(
                onClear: onClear,
                onConfirm: onConfirm,
                isClearEnabled: isClearEnabled,
                isConfirmEnabled: isConfirmEnabled,
                primaryActionText: String(localized: "confirm")
            )
        }
        .background(Color(.systemBackground))
    }
}
