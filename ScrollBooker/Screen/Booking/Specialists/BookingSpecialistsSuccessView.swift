//
//  BookingSpecialistsSuccessView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.07.2026.
//

import SwiftUI

struct BookingSpecialistsSuccessView: View {
    let bookingFlow: BookingFlow
    let viewModel: BookingViewModel
    let onNavigateToDateTime: () -> Void

    @State private var isSelectSpecialistsSheetPresented = false

    var body: some View {
        let allowedEmployeeIds = Set(
            viewModel.selectedBookingItems.flatMap { item in
                item.offerings.map { $0.user.id }
            }
        )

        let filteredEmployees = bookingFlow.employees.filter { employee in
            allowedEmployeeIds.contains(employee.id)
        }

        let selectedEmployee = filteredEmployees.first { $0.id == viewModel.selectedEmployeeId }

        let hasUnavailableItem = viewModel.selectedBookingItems.contains { item in
            !item.offerings.contains { $0.user.id == viewModel.selectedEmployeeId }
        }

        VStack(alignment: .leading, spacing: 16) {
            Text(String(localized: "chooseSpecialist"))
                .font(.largeTitle)
                .fontWeight(.black)
                .foregroundColor(.onBackgroundSB)
                .padding(.horizontal, 24)
                .padding(.top, 16)

            EmployeeSelectDropdown(
                selectedEmployee: selectedEmployee,
                onClick: { isSelectSpecialistsSheetPresented = true }
            )
            .padding(.horizontal, 24)

            if viewModel.selectedEmployeeId == nil {
                PlaceholderActionBoxView(
                    description: String(localized: "chooseSpecialistDescription"),
                    icon: nil
                )
                .padding(.horizontal, 24)
            } else {
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(viewModel.selectedBookingItems) { item in
                            let currentOffering = item.offerings.first { $0.user.id == viewModel.selectedEmployeeId }
                            
                            ProductOfferingCardView(
                                item: item,
                                selectedEmployeeId: viewModel.selectedEmployeeId,
                                employees: filteredEmployees,
                                currentOffering: currentOffering,
                                onRemoveItem: {
                                    withAnimation(.easeInOut(duration: 0.25)) {
                                        viewModel.removeBookingItem(item)
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 24)
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            BookingBottomBar(
                bookingTotals: viewModel.bookingTotals,
                onNext: onNavigateToDateTime,
                isEnabled: viewModel.selectedEmployeeId != nil && !hasUnavailableItem,
                isVisible: true
            )
        }
        .sheet(isPresented: $isSelectSpecialistsSheetPresented) {
            SelectSpecialistsSheetView(
                employees: filteredEmployees,
                selectedEmployee: selectedEmployee,
                onConfirmEmployee: { employee in
                    withAnimation(.easeInOut(duration: 0.25)) {
                        viewModel.setSelectedEmployeeId(employee.id)
                    }
                    isSelectSpecialistsSheetPresented = false
                },
                onClose: { isSelectSpecialistsSheetPresented = false }
            )
            .presentationDetents([.medium, .large])
        }
    }
}
