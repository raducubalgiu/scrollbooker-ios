//
//  MyCalendarEmployeeSheetView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.09.2026.
//

import SwiftUI

struct MyCalendarEmployeeSheetView: View {
    let employeesState: FeatureState<[Employee]>
    let selectedEmployeeId: Int?
    let employeesAvailability: [Int: Bool]
    var onSelect: (Int) -> Void
    var onClose: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            SheetHeaderView(onDismiss: onClose, title: String(localized: "employee"))

            switch employeesState {
                case .idle, .loading:
                    LoadingView()

                case .error:
                    ErrorView(message: String(localized: "message_error_something_went_wrong"), retryAction: {})

                case .success(let employees):
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(employees) { employee in
                                MyCalendarEmployeeRowView(
                                    employee: employee,
                                    isSelected: employee.id == selectedEmployeeId,
                                    hasAvailability: employeesAvailability[employee.id],
                                    onSelect: { onSelect(employee.id) }
                                )

                                if employee.id != employees.last?.id {
                                    Divider()
                                }
                            }
                        }
                        .padding(.horizontal, .base)
                    }
            }
        }
        .frame(maxHeight: .infinity)
    }
}
