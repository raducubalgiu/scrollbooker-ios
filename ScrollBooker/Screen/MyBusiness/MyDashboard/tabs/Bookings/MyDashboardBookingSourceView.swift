//
//  MyDashboardBookingSourceView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import SwiftUI

struct MyDashboardBookingSourceView: View {
    let sources: [DashboardBookingSource]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            StatTitleView(title: String(localized: "bookingsSources"))
                .padding(.bottom, .m)

            VStack(spacing: AppSize.m.rawValue) {
                ForEach(Array(sources.enumerated()), id: \.offset) { _, source in
                    StatBarRowView(
                        label: source.source?.rawValue ?? "",
                        valueString: "\(source.bookingsNo)",
                        progressPercentage: source.percentage
                    )
                }
            }
        }
        .padding(.base)
        .background(Color.backgroundSB)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
