//
//  MyDashboardBookingDetailsView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import SwiftUI

struct MyDashboardBookingDetailsView: View {
    let dashboardBooking: DashboardBooking
    let periodText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            StatTitleView(title: String(localized: "bookingsDetails"))
                .padding(.bottom, .xxs)

            Text(periodText)
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom, .m)

            HStack(spacing: AppSize.m.rawValue) {
                StatCardView(
                    label: String(localized: "bookings"),
                    value: "\(dashboardBooking.bookingsNo)",
                    containerColor: .clear,
                    contentColor: .onBackgroundSB,
                    borderColor: .dividerSB
                )
                StatCardView(
                    label: String(localized: "earnings"),
                    value: "\(dashboardBooking.revenue.toTwoDecimals()) RON",
                    containerColor: .clear,
                    contentColor: .onBackgroundSB,
                    borderColor: .dividerSB
                )
            }

            Spacer().frame(height: AppSize.m.rawValue)

            HStack(spacing: AppSize.m.rawValue) {
                StatCardView(
                    label: String(localized: "finished"),
                    value: "\(dashboardBooking.finishedBookingsNo)",
                    containerColor: .clear,
                    contentColor: .onBackgroundSB,
                    borderColor: .dividerSB
                )
                StatCardView(
                    label: String(localized: "canceled"),
                    value: "\(dashboardBooking.cancelledBookingsNo)",
                    containerColor: .clear,
                    contentColor: .onBackgroundSB,
                    borderColor: .dividerSB
                )
            }

            Spacer().frame(height: AppSize.m.rawValue)

            HStack(spacing: AppSize.m.rawValue) {
                StatCardView(
                    label: String(localized: "fromvideo"),
                    value: "\(dashboardBooking.revenueFromVideo.toTwoDecimals()) RON",
                    containerColor: .clear,
                    contentColor: .onBackgroundSB,
                    borderColor: .dividerSB
                )
                StatCardView(
                    label: String(localized: "scrollBookerCommission"),
                    value: "\(dashboardBooking.revenueScrollBooker.toTwoDecimals()) RON",
                    contentColor: .onBackgroundSB,
                    borderColor: Color.primarySB.opacity(0.5),
                    gradientColors: [
                        Color.primarySB.opacity(0.15),
                        Color.primarySB.opacity(0.02)
                    ]
                )
            }

            Spacer().frame(height: AppSize.m.rawValue)

            DonutChartView(
                title: String(localized: "channel"),
                entries: dashboardBooking.channels.map { channel in
                    DonutChartEntry(
                        label: channel.channel?.title ?? "",
                        value: channel.bookingsNo,
                        color: .primarySB
                    )
                }
            )
        }
        .padding(.base)
        .background(Color.backgroundSB)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
