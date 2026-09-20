//
//  SelectSpecialistsSheetView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.09.2026.
//

import SwiftUI

struct SelectSpecialistsSheetView: View {
    let employees: [BookingFlowUser]
    let selectedEmployee: BookingFlowUser?
    var onConfirmEmployee: (BookingFlowUser) -> Void
    var onClose: () -> Void

    @State private var selectedLocally: BookingFlowUser?

    var body: some View {
        VStack(spacing: 0) {
            SheetHeaderView(onDismiss: onClose, title: String(localized: "employees"))

            ScrollView {
                VStack(spacing: 0) {
                    ForEach(employees) { specialist in
                        SpecialistSelectRowView(
                            specialist: specialist,
                            isSelected: selectedLocally?.id == specialist.id,
                            onSelect: { selectedLocally = specialist }
                        )
                        .padding(.horizontal, .base)

                        if specialist.id != employees.last?.id {
                            Divider()
                                .padding(.horizontal, .base)
                                .padding(.vertical, .base)
                        }
                    }
                }
                .padding(.vertical, .base)
            }

            MainButton(
                title: String(localized: "add"),
                isDisabled: selectedLocally == nil,
                onClick: {
                    if let selectedLocally {
                        onConfirmEmployee(selectedLocally)
                    }
                }
            )
            .padding(.base)
        }
        .onAppear {
            selectedLocally = selectedEmployee
        }
    }
}
