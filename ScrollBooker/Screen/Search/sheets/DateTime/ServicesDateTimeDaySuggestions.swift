//
//  ServicesDateTimeDaySuggestions.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.07.2026.
//

import SwiftUI

struct ServicesDateTimeDaySuggestions: View {
    let isTodaySelected: Bool
    let isTomorrowSelected: Bool
    var onTodayClick: () -> Void
    var onTomorrowClick: () -> Void

    var body: some View {
        HStack(spacing: AppSize.m.rawValue) {
            TimeIntervalCardView(
                title: String(localized: "today"),
                isSelected: isTodaySelected,
                fillsWidth: true,
                onTap: onTodayClick
            )

            TimeIntervalCardView(
                title: String(localized: "tomorrow"),
                isSelected: isTomorrowSelected,
                fillsWidth: true,
                onTap: onTomorrowClick
            )
        }
    }
}
