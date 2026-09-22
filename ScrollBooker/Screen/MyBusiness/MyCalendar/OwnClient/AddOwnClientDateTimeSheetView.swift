//
//  AddOwnClientDateTimeSheetView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.09.2026.
//

import SwiftUI

struct AddOwnClientDateTimeSheetView: View {
    @Environment(\.dismiss) private var dismiss
    let viewModel: AddOwnClientViewModel

    var body: some View {
        VStack(spacing: 0) {
            SheetHeaderView(onDismiss: { dismiss() }, title: String(localized: "selectDateAndTime"), showDivider: false)

            switch viewModel.calendarHeaderState {
                case .idle, .loading:
                    LoadingView()

                case .error(let message):
                    ErrorView(message: message) {
                        Task { await viewModel.loadCalendarHeader() }
                    }

                case .success(let headerData):
                    AddOwnClientCalendarSuccessView(
                        availableDays: headerData.availableDays,
                        allCalendarDays: headerData.allCalendarDays,
                        viewModel: viewModel,
                        onSlotConfirmed: { dismiss() }
                    )
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .task {
            await viewModel.loadCalendarHeader()
        }
    }
}
