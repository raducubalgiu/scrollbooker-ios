//
//  AddOwnClientBottomBarView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.09.2026.
//

import SwiftUI

struct AddOwnClientBottomBarView: View {
    let viewModel: AddOwnClientViewModel
    var onOpenDateTimeSelect: () -> Void
    var onSave: () -> Void

    private var selectedSlotLabel: String? {
        guard let selectedSlot = viewModel.selectedSlot,
              let start = selectedSlot.startDateLocale.asLocalDateTime(),
              let end = selectedSlot.endDateLocale.asLocalDateTime() else { return nil }

        let datePart = start.formatted(.dateTime.day().month(.wide))
        let startTime = start.formatted(.dateTime.hour().minute())
        let endTime = end.formatted(.dateTime.hour().minute())

        if let duration = viewModel.selectedSlotDurationMinutes {
            return "\(datePart), \(startTime) - \(endTime) (\(duration) min)"
        }
        return "\(datePart), \(startTime)"
    }

    var body: some View {
        VStack(spacing: 0) {
            Divider()

            HStack {
                Text("\(String(localized: "duration")): \(viewModel.totalDuration) min")
                    .font(.subheadline.weight(.medium))

                Spacer()

                Text("\(String(localized: "total")): \(viewModel.totalPriceWithDiscount.toTwoDecimals()) RON")
                    .font(.subheadline.weight(.medium))
            }
            .padding(.horizontal, .base)
            .padding(.vertical, .s)

            AddOwnClientDateTimeSummaryButtonView(
                value: selectedSlotLabel,
                isEnabled: viewModel.totalDuration > 0,
                onClick: onOpenDateTimeSelect
            )
            .padding(.horizontal, .base)

            if viewModel.hasDurationMismatch, let mismatchDuration = viewModel.selectedSlotDurationMinutes {
                Text(String(format: String(localized: "appointmentDurationMismatch"), viewModel.totalDuration, mismatchDuration))
                    .font(.footnote)
                    .foregroundColor(.errorSB)
                    .padding(.horizontal, .base)
                    .padding(.top, .xs)
            }

            MainButton(
                title: String(localized: "saveAppointment"),
                isDisabled: !viewModel.canSave,
                isLoading: viewModel.isSaving,
                onClick: onSave
            )
            .padding(.base)
        }
        .background(Color.backgroundSB)
    }
}
