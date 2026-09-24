//
//  AddOwnClientDateTimeSheetView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.09.2026.
//

import SwiftUI

struct AddOwnClientDateTimeSheetView: View {
    let viewModel: AddOwnClientViewModel
    var onClose: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            SheetHeaderView(onDismiss: onClose, title: String(localized: "selectDateAndTime"), showDivider: false)

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
                        onSlotConfirmed: onClose
                    )
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .task {
            await viewModel.loadCalendarHeader()
        }
    }
}
