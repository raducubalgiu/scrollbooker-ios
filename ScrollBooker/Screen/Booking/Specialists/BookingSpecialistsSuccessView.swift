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
    
    var body: some View {
        let allowedEmployeeIds = Set(
            viewModel.selectedBookingItems.flatMap { item in
                item.offerings.map { $0.user.id }
            }
        )
        
        let filteredEmployees = bookingFlow.employees.filter { employee in
            allowedEmployeeIds.contains(employee.id)
        }
        
        VStack(alignment: .leading, spacing: 16) {
            Text("Alege Specialistul")
                .font(.largeTitle)
                .fontWeight(.black)
                .foregroundColor(.onBackgroundSB)
                .padding(.horizontal, 24)
                .padding(.top, 16)
            
            EmployeeSelectDropdown(
                selectedEmployeeId: viewModel.selectedEmployeeId,
                employees: filteredEmployees,
                onEmployeeSelected: { id in
                    withAnimation(.easeInOut(duration: 0.25)) {
                        viewModel.setSelectedEmployeeId(id)
                    }
                }
            )
            .padding(.horizontal, 24)
            
            if viewModel.selectedEmployeeId == nil {
                UnselectedSpecialistOverlay()
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
                isEnabled: viewModel.selectedEmployeeId != nil,
                isVisible: true
            )
        }
    }
}
