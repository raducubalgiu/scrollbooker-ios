//
//  MyCalendarSettingsScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import SwiftUI

struct MyCalendarSettingsScreen: View {
    @State var viewModel: MyCalendarViewModel
    var onBack: () -> Void

    private enum PickerKind: Identifiable {
        case duration
        case gap

        var id: Self { self }
    }

    @State private var activePicker: PickerKind?

    var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: String(localized: "calendarSettings"), onBack: onBack)

            ScrollView {
                VStack(spacing: 0) {
                    MyCalendarSettingsRowView(
                        title: String(localized: "slotDurationSectionTitle"),
                        description: String(localized: "slotDurationSectionDescription"),
                        value: MyCalendarDurationOptions.label(forSlotDuration: viewModel.slotDurationMinutes),
                        onTap: { activePicker = .duration }
                    )

                    if viewModel.canSetAppointmentGap {
                        Divider()

                        MyCalendarSettingsRowView(
                            title: String(localized: "appointmentGapSectionTitle"),
                            description: String(localized: "appointmentGapSectionDescription"),
                            value: MyCalendarDurationOptions.label(forGap: viewModel.appointmentGapMinutes),
                            onTap: { activePicker = .gap }
                        )
                    }
                }
                .padding(.horizontal, .base)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundSB)
        .sheet(item: $activePicker) { picker in
            switch picker {
                case .duration:
                    MyCalendarDurationPickerSheetView(
                        title: String(localized: "slotDurationSectionTitle"),
                        options: MyCalendarDurationOptions.slotDurationOptions,
                        selectedMinutes: viewModel.slotDurationMinutes,
                        isSaving: viewModel.isSavingCalendarSettings,
                        onSave: { minutes in Task { await viewModel.saveSlotDuration(minutes) } },
                        onClose: { activePicker = nil }
                    )
                    .presentationDetents([.fraction(0.5)])

                case .gap:
                    MyCalendarDurationPickerSheetView(
                        title: String(localized: "appointmentGapSectionTitle"),
                        options: MyCalendarDurationOptions.appointmentGapOptions,
                        selectedMinutes: viewModel.appointmentGapMinutes,
                        isSaving: viewModel.isSavingCalendarSettings,
                        onSave: { minutes in Task { await viewModel.saveAppointmentGap(minutes) } },
                        onClose: { activePicker = nil }
                    )
                    .presentationDetents([.fraction(0.5)])
            }
        }
    }
}
