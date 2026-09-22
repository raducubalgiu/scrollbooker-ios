//
//  MyCalendarModule.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import Foundation

@MainActor
final class MyCalendarModule {
    func makeMyCalendarViewModel(
        userId: Int,
        businessId: Int,
        businessOwnerId: Int?,
        hasEmployees: Bool,
        ownAvatar: String?,
        ownFullName: String,
        getUserAvailableDaysUseCase: GetUserAvailableDaysUseCase,
        getUserCalendarEventsUseCase: GetUserCalendarEventsUseCase,
        getSchedulesByUserIdUseCase: GetSchedulesByUserIdUseCase,
        getUserCalendarSettingsUseCase: GetUserCalendarSettingsUseCase,
        updateSlotDurationUseCase: UpdateSlotDurationUseCase,
        updateAppointmentGapUseCase: UpdateAppointmentGapUseCase,
        createBlockAppointmentsUseCase: CreateBlockAppointmentsUseCase,
        getEmployeesByOwnerUseCase: GetEmployeesByOwnerUseCase,
        getEmployeesAvailabilityForDayUseCase: GetEmployeesAvailabilityForDayUseCase,
        toastCenter: ToastCenter
    ) -> MyCalendarViewModel {
        MyCalendarViewModel(
            userId: userId,
            businessId: businessId,
            businessOwnerId: businessOwnerId,
            hasEmployees: hasEmployees,
            ownAvatar: ownAvatar,
            ownFullName: ownFullName,
            getUserAvailableDaysUseCase: getUserAvailableDaysUseCase,
            getUserCalendarEventsUseCase: getUserCalendarEventsUseCase,
            getSchedulesByUserIdUseCase: getSchedulesByUserIdUseCase,
            getUserCalendarSettingsUseCase: getUserCalendarSettingsUseCase,
            updateSlotDurationUseCase: updateSlotDurationUseCase,
            updateAppointmentGapUseCase: updateAppointmentGapUseCase,
            createBlockAppointmentsUseCase: createBlockAppointmentsUseCase,
            getEmployeesByOwnerUseCase: getEmployeesByOwnerUseCase,
            getEmployeesAvailabilityForDayUseCase: getEmployeesAvailabilityForDayUseCase,
            toastCenter: toastCenter
        )
    }
}
