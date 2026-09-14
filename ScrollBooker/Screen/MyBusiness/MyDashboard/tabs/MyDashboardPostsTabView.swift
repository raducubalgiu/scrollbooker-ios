//
//  MyDashboardPostsTabView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import SwiftUI

// Not implemented yet — mirrors Android's MyDashboardPostsTab, which is also just
// a disconnected PeriodSelector stub for now, with no real data wired up.
struct MyDashboardPostsTabView: View {
    @State private var selectedPeriod: DashboardPeriod = .sevenDays

    var body: some View {
        VStack(spacing: 0) {
            PeriodSelectorView(
                selectedPeriod: selectedPeriod,
                onPeriodSelected: { selectedPeriod = $0 }
            )

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
