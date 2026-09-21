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
        getUserAvailableDaysUseCase: GetUserAvailableDaysUseCase,
        getUserCalendarEventsUseCase: GetUserCalendarEventsUseCase,
        getSchedulesByUserIdUseCase: GetSchedulesByUserIdUseCase,
        getUserCalendarSettingsUseCase: GetUserCalendarSettingsUseCase,
        updateSlotDurationUseCase: UpdateSlotDurationUseCase,
        updateAppointmentGapUseCase: UpdateAppointmentGapUseCase,
        createBlockAppointmentsUseCase: CreateBlockAppointmentsUseCase,
        toastCenter: ToastCenter
    ) -> MyCalendarViewModel {
        MyCalendarViewModel(
            userId: userId,
            businessId: businessId,
            businessOwnerId: businessOwnerId,
            hasEmployees: hasEmployees,
            getUserAvailableDaysUseCase: getUserAvailableDaysUseCase,
            getUserCalendarEventsUseCase: getUserCalendarEventsUseCase,
            getSchedulesByUserIdUseCase: getSchedulesByUserIdUseCase,
            getUserCalendarSettingsUseCase: getUserCalendarSettingsUseCase,
            updateSlotDurationUseCase: updateSlotDurationUseCase,
            updateAppointmentGapUseCase: updateAppointmentGapUseCase,
            createBlockAppointmentsUseCase: createBlockAppointmentsUseCase,
            toastCenter: toastCenter
        )
    }
}
