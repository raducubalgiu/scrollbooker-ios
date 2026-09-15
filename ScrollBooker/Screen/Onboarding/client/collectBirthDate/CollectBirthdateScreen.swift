//
//  CollectBirthdateScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

struct CollectBirthdateScreen: View {
    @Bindable var viewModel: CollectBirthdateViewModel
    let onBack: () -> Void

    private var dateRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let start = calendar.date(from: DateComponents(year: 1900, month: 1, day: 1)) ?? .distantPast
        let end = Date()
        return start...end
    }

    var body: some View {
        FormLayout(
            headline: String(localized: "dateOfBirth"),
            subHeadline: String(localized: "dateOfBirthLabelDescription"),
            enableBack: false,
            buttonTitle: String(localized: "nextStep"),
            isDisabled: viewModel.isSaving,
            isLoading: viewModel.isSaving,
            onBack: onBack,
            onClick: { Task { await viewModel.collectBirthdate() } }
        ) {
            DatePicker(
                "",
                selection: $viewModel.selectedBirthdate,
                in: dateRange,
                displayedComponents: [.date]
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            .frame(maxWidth: .infinity)

            Button {
                Task { await viewModel.collectBirthdate(skip: true) }
            } label: {
                Text(String(localized: "preferNotToSay"))
            }
            .disabled(viewModel.isSaving)
            .frame(maxWidth: .infinity)
            .foregroundColor(.primarySB)
            .fontWeight(.bold)
        }
    }
}
