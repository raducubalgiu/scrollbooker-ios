//
//  MainFiltersFooter.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.07.2026.
//

import SwiftUI

struct MainFiltersFooter: View {
    var isClearEnabled: Bool = true
    var isConfirmEnabled: Bool = true
    var onConfirm: () -> Void
    var onClear: () -> Void

    var serviceSummary: String
    var isServiceActive: Bool
    var onOpenService: () -> Void
    var onClearService: () -> Void

    var dateTimeSummary: String
    var isDateTimeActive: Bool
    var onOpenDateTime: () -> Void
    var onClearDateTime: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color(.systemGray4))
                .frame(height: 0.55)
                .padding(.bottom, 16)

            HStack(spacing: AppSize.base.rawValue) {
                SelectionChipButton(
                    icon: "list.bullet",
                    title: serviceSummary,
                    isActive: isServiceActive,
                    isEnabled: isServiceActive,
                    onTap: onOpenService,
                    onClear: onClearService
                )

                SelectionChipButton(
                    icon: "clock",
                    title: dateTimeSummary,
                    isActive: isDateTimeActive,
                    onTap: onOpenDateTime,
                    onClear: onClearDateTime
                )
            }
            .padding(.horizontal, 16)

            Spacer().frame(height: 16)

            SearchSheetActions(
                onClear: onClear,
                onConfirm: onConfirm,
                isClearEnabled: isClearEnabled,
                isConfirmEnabled: isConfirmEnabled
            )
        }
        .background(Color(.systemBackground))
    }
}
