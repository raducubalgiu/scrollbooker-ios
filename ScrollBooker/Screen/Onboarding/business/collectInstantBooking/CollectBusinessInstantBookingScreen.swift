//
//  CollectBusinessInstantBookingScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.10.2026.
//

import SwiftUI

struct CollectBusinessInstantBookingScreen: View {
    @Bindable var viewModel: CollectBusinessInstantBookingViewModel
    let onBack: () -> Void

    var body: some View {
        FormLayout(
            headline: String(localized: "onboarding_instant_booking_title"),
            subHeadline: String(localized: "onboarding_instant_booking_description"),
            enableBack: true,
            buttonTitle: String(localized: "nextStep"),
            isDisabled: !viewModel.isSubmitEnabled,
            isLoading: viewModel.isSaving,
            onBack: onBack,
            onClick: { Task { await viewModel.collectBusinessInstantBooking() } }
        ) {
            VStack(alignment: .leading, spacing: AppSize.base.rawValue) {
                VStack(alignment: .leading, spacing: AppSize.m.rawValue) {
                    InstantBookingBenefitRowView(
                        icon: "calendar",
                        title: String(localized: "onboarding_instant_booking_benefit_calendar_title"),
                        description: String(localized: "onboarding_instant_booking_benefit_calendar_description")
                    )

                    InstantBookingBenefitRowView(
                        icon: "chart.bar.fill",
                        title: String(localized: "onboarding_instant_booking_benefit_stats_title"),
                        description: String(localized: "onboarding_instant_booking_benefit_stats_description")
                    )

                    InstantBookingBenefitRowView(
                        icon: "bolt.fill",
                        title: String(localized: "onboarding_instant_booking_benefit_bookings_title"),
                        description: String(localized: "onboarding_instant_booking_benefit_bookings_description")
                    )
                }
                .padding(.bottom, .s)

                Divider()

                VStack(alignment: .leading, spacing: AppSize.xs.rawValue) {
                    InputRadio(
                        title: String(localized: "onboarding_instant_booking_yes"),
                        isSelected: viewModel.instantBooking == true,
                        titleFontWeight: .semibold,
                        onClick: { viewModel.instantBooking = true }
                    )

                    Text(
                        viewModel.hasEmployees
                        ? String(localized: "onboarding_instant_booking_yes_description_with_employees")
                        : String(localized: "onboarding_instant_booking_yes_description")
                    )
                    .font(.footnote)
                    .foregroundColor(.gray)
                }

                Divider()

                VStack(alignment: .leading, spacing: AppSize.xs.rawValue) {
                    InputRadio(
                        title: String(localized: "onboarding_instant_booking_no"),
                        isSelected: viewModel.instantBooking == false,
                        titleFontWeight: .semibold,
                        onClick: { viewModel.instantBooking = false }
                    )

                    Text(String(localized: "onboarding_instant_booking_no_description"))
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, .xl)
        }
    }
}
