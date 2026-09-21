//
//  TimeSection.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import SwiftUI

struct TimeSection: View {
    var startTime: String?
    var endTime: String?
    var onTimeChange: (String?, String?) -> Void

    @State private var showStartPicker = false
    @State private var showEndPicker = false

    private var currentPreset: TimeIntervalPreset {
        switch (startTime, endTime) {
            case (nil, nil):
                return .anytime
            case (TimeIntervalPreset.morning.start, TimeIntervalPreset.morning.end):
                return .morning
            case (TimeIntervalPreset.lunch.start, TimeIntervalPreset.lunch.end):
                return .lunch
            case (TimeIntervalPreset.evening.start, TimeIntervalPreset.evening.end):
                return .evening
            default:
                return .custom
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppSize.base.rawValue) {
            Text(String(localized: "timeInterval"))
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.onBackgroundSB)
                .padding(.horizontal, AppSize.base.rawValue)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppSize.m.rawValue) {
                    ForEach(TimeIntervalPreset.allCases, id: \.self) { preset in
                        TimeIntervalCardView(
                            title: preset.label,
                            description: preset.description,
                            isSelected: currentPreset == preset,
                            onTap: {
                                if preset == .custom {
                                    onTimeChange(startTime ?? "09:00", endTime ?? "18:00")
                                } else {
                                    onTimeChange(preset.start, preset.end)
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, AppSize.base.rawValue)
            }

            if currentPreset == .custom {
                HStack(spacing: AppSize.m.rawValue) {
                    TimeFieldButton(
                        label: String(localized: "from"),
                        value: startTime,
                        onTap: { showStartPicker = true }
                    )

                    TimeFieldButton(
                        label: String(localized: "until"),
                        value: endTime,
                        onTap: { showEndPicker = true }
                    )
                }
                .padding(.horizontal, AppSize.base.rawValue)
            }
        }
        .sheet(isPresented: $showStartPicker) {
            TimePickerSheet(
                initialTime: startTime,
                onConfirm: { newValue in
                    onTimeChange(newValue, endTime)
                    showStartPicker = false
                },
                onCancel: { showStartPicker = false }
            )
            .presentationDetents([.height(320)])
        }
        .sheet(isPresented: $showEndPicker) {
            TimePickerSheet(
                initialTime: endTime,
                onConfirm: { newValue in
                    onTimeChange(startTime, newValue)
                    showEndPicker = false
                },
                onCancel: { showEndPicker = false }
            )
            .presentationDetents([.height(320)])
        }
    }
}
