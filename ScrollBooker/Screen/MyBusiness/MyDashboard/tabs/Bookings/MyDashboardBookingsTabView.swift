//
//  MyDashboardBookingsTabView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import SwiftUI

struct MyDashboardBookingsTabView: View {
    let viewModel: MyDashboardViewModel

    var body: some View {
        VStack(spacing: 0) {
            PeriodSelectorView(
                selectedPeriod: viewModel.selectedPeriod,
                onPeriodSelected: { viewModel.onPeriodSelected($0) }
            )

            switch viewModel.dashboardBookingState {
            case .idle, .loading:
                LoadingView()

            case .error:
                ErrorView(message: String(localized: "somethingWentWrong")) {
                    Task { await viewModel.loadDashboardBooking() }
                }

            case .success(let data):
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: AppSize.s.rawValue) {
                        MyDashboardBookingDetailsView(
                            dashboardBooking: data,
                            periodText: viewModel.selectedDateRange.format()
                        )

                        MyDashboardBookingSourceView(sources: data.sources)
                    }
                    .padding(.horizontal, .s)
                    .padding(.bottom, .base)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task {
            await viewModel.loadDashboardBooking()
        }
    }
}
