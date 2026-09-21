//
//  MyCalendarDurationPickerSheetView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import SwiftUI

struct MyCalendarDurationPickerSheetView: View {
    let title: String
    let options: [MyCalendarDurationOption]
    let selectedMinutes: Int
    let isSaving: Bool
    var onSave: (Int) -> Void
    var onClose: () -> Void

    @State private var localSelection: Int
    @State private var pendingSave: Int?

    init(
        title: String,
        options: [MyCalendarDurationOption],
        selectedMinutes: Int,
        isSaving: Bool,
        onSave: @escaping (Int) -> Void,
        onClose: @escaping () -> Void
    ) {
        self.title = title
        self.options = options
        self.selectedMinutes = selectedMinutes
        self.isSaving = isSaving
        self.onSave = onSave
        self.onClose = onClose
        self._localSelection = State(initialValue: selectedMinutes)
    }

    private var isConfirmEnabled: Bool {
        localSelection != selectedMinutes && !isSaving
    }

    var body: some View {
        VStack(spacing: 0) {
            SheetHeaderView(onDismiss: onClose, title: title)

            ForEach(options) { option in
                InputRadio(
                    title: option.label,
                    isSelected: option.minutes == localSelection,
                    onClick: { localSelection = option.minutes }
                )
                .padding(.horizontal, .base)

                if option.id != options.last?.id {
                    Divider().padding(.horizontal, .base)
                }
            }

            Divider()

            MainButton(
                title: String(localized: "save"),
                isDisabled: !isConfirmEnabled,
                isLoading: isSaving,
                onClick: {
                    pendingSave = localSelection
                    onSave(localSelection)
                }
            )
            .padding(.base)
        }
        .onChange(of: selectedMinutes) { _, newValue in
            if let pendingSave, newValue == pendingSave {
                onClose()
            }
        }
    }
}
