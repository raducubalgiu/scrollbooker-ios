//
//  CollectBusinessHasEmployeesScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct CollectBusinessHasEmployeesScreen: View {
    @Bindable var viewModel: CollectBusinessHasEmployeesViewModel
    let onBack: () -> Void

    var body: some View {
        FormLayout(
            headline: String(localized: "onboarding_has_employee_title"),
            subHeadline: "",
            enableBack: true,
            buttonTitle: String(localized: "nextStep"),
            isDisabled: !viewModel.isSubmitEnabled,
            isLoading: viewModel.isSaving,
            onBack: onBack,
            onClick: { Task { await viewModel.collectBusinessHasEmployees() } }
        ) {
            VStack(alignment: .leading, spacing: AppSize.base.rawValue) {
                VStack(alignment: .leading, spacing: AppSize.xs.rawValue) {
                    InputRadio(
                        title: String(localized: "onboarding_has_employee_yes"),
                        isSelected: viewModel.hasEmployees == true,
                        titleFontWeight: .semibold,
                        onClick: { viewModel.hasEmployees = true }
                    )

                    Text(String(localized: "onboarding_has_employee_yes_description"))
                        .font(.footnote)
                        .foregroundColor(.gray)
                }

                Divider()

                VStack(alignment: .leading, spacing: AppSize.xs.rawValue) {
                    InputRadio(
                        title: String(localized: "onboarding_has_employee_no"),
                        isSelected: viewModel.hasEmployees == false,
                        titleFontWeight: .semibold,
                        onClick: { viewModel.hasEmployees = false }
                    )

                    Text(String(localized: "onboarding_has_employee_no_description"))
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, .xl)
        }
    }
}
