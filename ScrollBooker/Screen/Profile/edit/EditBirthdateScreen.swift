//
//  EditBirthdateScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 06.07.2026.
//

import SwiftUI

struct EditBirthdateScreen: View {
    @Bindable var viewModel: MyProfileViewModel
    var onBack: () -> Void
    
    private var isButtonDisabled: Bool {
        viewModel.isLoading
    }
    
    var body: some View {
        FormLayout(
            headline: String(localized: "dateOfBirth"),
            subHeadline: String(localized: "dateOfBirthLabelDescription"),
            enableBottomButton: true,
            enableBack: true,
            buttonTitle: String(localized: "save"),
            isDisabled: isButtonDisabled,
            isLoading: viewModel.isLoading,
            onBack: onBack,
            onClick: {
                Task { await viewModel.updateBirthDate() }
            }
        ) {
            DatePicker(
                "",
                selection: $viewModel.selectedBirthdate,
                in: ...Date(),
                displayedComponents: [.date]
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            .frame(maxWidth: .infinity)
            .padding(.top, .base)
        }
        .onAppear {
            if let birthDateStr = viewModel.profileController.uiState.data?.dateOfBirth, !birthDateStr.isEmpty {
                let formatter = ISO8601DateFormatter()
                formatter.formatOptions = [.withFullDate]
                if let parsedDate = formatter.date(from: birthDateStr) {
                    viewModel.selectedBirthdate = parsedDate
                }
            }
        }
        .onChange(of: viewModel.isSaved) { _, saved in
            if saved {
                onBack()
                viewModel.isSaved = false
            }
        }
    }
}
