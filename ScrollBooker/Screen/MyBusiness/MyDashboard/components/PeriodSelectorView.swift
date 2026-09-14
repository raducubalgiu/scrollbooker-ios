//
//  PeriodSelectorView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import SwiftUI

struct PeriodSelectorView: View {
    let selectedPeriod: DashboardPeriod
    let onPeriodSelected: (DashboardPeriod) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSize.s.rawValue) {
                ForEach(DashboardPeriod.allCases, id: \.self) { period in
                    let isSelected = period == selectedPeriod

                    Text(period.title)
                        .font(.subheadline.weight(isSelected ? .bold : .regular))
                        .foregroundColor(isSelected ? .white : .gray)
                        .padding(.horizontal, .base)
                        .padding(.vertical, .xs)
                        .background(isSelected ? Color.onBackgroundSB : Color.backgroundSB)
                        .clipShape(Capsule())
                        .onTapGesture {
                            onPeriodSelected(period)
                        }
                }
            }
            .padding(.horizontal, .base)
            .padding(.vertical, .s)
        }
    }
}
