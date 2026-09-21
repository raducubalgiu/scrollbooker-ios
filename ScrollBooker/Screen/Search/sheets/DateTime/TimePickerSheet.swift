//
//  TimePickerSheet.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import SwiftUI

struct TimePickerSheet: View {
    var initialTime: String?
    var onConfirm: (String) -> Void
    var onCancel: () -> Void

    @State private var selectedTime: Date

    init(
        initialTime: String?,
        onConfirm: @escaping (String) -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.initialTime = initialTime
        self.onConfirm = onConfirm
        self.onCancel = onCancel

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        if let initialTime, let date = formatter.date(from: initialTime) {
            self._selectedTime = State(initialValue: date)
        } else {
            self._selectedTime = State(initialValue: Date())
        }
    }

    var body: some View {
        VStack(spacing: AppSize.base.rawValue) {
            DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(.wheel)
                .labelsHidden()

            HStack(spacing: AppSize.m.rawValue) {
                SheetActionButton(
                    title: String(localized: "cancel"),
                    style: .outlined,
                    onClick: onCancel
                )

                SheetActionButton(
                    title: String(localized: "add"),
                    style: .filled,
                    onClick: {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "HH:mm"
                        onConfirm(formatter.string(from: selectedTime))
                    }
                )
            }
        }
        .padding(AppSize.base.rawValue)
    }
}
