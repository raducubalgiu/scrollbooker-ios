//
//  AddOwnClientModule.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.09.2026.
//

import Foundation

@MainActor
final class AddOwnClientModule {
    func makeAddOwnClientViewModel(
        businessId: Int,
        employeeId: Int?,
        targetUserId: Int,
        initialDay: Date?,
        initialSlot: Slot?,
        getProductsByBusinessAndEmployeeUseCase: GetProductsbyBusinessAndEmployeeUseCase,
        getUserAvailableDaysUseCase: GetUserAvailableDaysUseCase,
        getUserAvailableTimeslotsUseCase: GetUserAvailableTimeslotsUseCase,
        getBusinessClientsUseCase: GetBusinessClientsUseCase,
        createBusinessClientUseCase: CreateBusinessClientUseCase,
        createOwnClientAppointmentUseCase: CreateOwnClientAppointmentUseCase,
        toastCenter: ToastCenter
    ) -> AddOwnClientViewModel {
        AddOwnClientViewModel(
            businessId: businessId,
            employeeId: employeeId,
            targetUserId: targetUserId,
            initialDay: initialDay,
            initialSlot: initialSlot,
            getProductsByBusinessAndEmployeeUseCase: getProductsByBusinessAndEmployeeUseCase,
            getUserAvailableDaysUseCase: getUserAvailableDaysUseCase,
            getUserAvailableTimeslotsUseCase: getUserAvailableTimeslotsUseCase,
            getBusinessClientsUseCase: getBusinessClientsUseCase,
            createBusinessClientUseCase: createBusinessClientUseCase,
            createOwnClientAppointmentUseCase: createOwnClientAppointmentUseCase,
            toastCenter: toastCenter
        )
    }
}
