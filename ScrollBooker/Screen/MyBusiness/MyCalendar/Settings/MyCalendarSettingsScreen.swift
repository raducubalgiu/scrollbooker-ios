//
//  MyCalendarSettingsScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import SwiftUI

struct MyCalendarSettingsScreen: View {
    @State var viewModel: MyCalendarViewModel
    var calendarConnectionViewModel: CalendarConnectionViewModel
    var onBack: () -> Void

    private enum PickerKind: Identifiable {
        case duration
        case gap

        var id: Self { self }
    }

    @State private var activePicker: PickerKind?
    @State private var showGoogleCalendarSheet = false

    var body: some View {
        VStack(spacing: 0) {
            HeaderView(
                title: String(localized: "calendarSettings"),
                enableBack: false,
                onBack: onBack,
                customAction: {
                    Button {
                        onBack()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.onBackgroundSB)
                    }
                }
            )

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

                    Divider()

                    MyCalendarSettingsRowView(
                        title: String(localized: "calendarConnection"),
                        description: String(localized: "calendarConnectionDescription"),
                        value: calendarConnectionViewModel.statusLabel,
                        onTap: { showGoogleCalendarSheet = true }
                    )
                }
                .padding(.base)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundSB)
        .task {
            await calendarConnectionViewModel.loadConnection()
        }
        .sheet(isPresented: $showGoogleCalendarSheet) {
            CalendarConnectionSheetView(viewModel: calendarConnectionViewModel)
                .presentationDetents([.fraction(0.5)])
                .presentationDragIndicator(.hidden)
                .presentationCornerRadius(25)
        }
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
                    .presentationDragIndicator(.hidden)
                    .presentationCornerRadius(25)

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
                    .presentationDragIndicator(.hidden)
                    .presentationCornerRadius(25)
            }
        }
    }
}
