//
//  BookingFlowModule.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.07.2026.
//

import Foundation

@MainActor
final class BookingFlowModule {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    private lazy var apiService: BookingFlowApiService = {
        BookingFlowAPIImpl(client: apiClient)
    }()

    private lazy var repository: BookingFlowRepository = {
        BookingFlowRepositoryImpl(api: apiService)
    }()

    private lazy var getBookingFlowUseCase: GetBookingFlowUseCase = {
        GetBookingFlowUseCase(repository: repository)
    }()
    
    func makeBookingFlowViewModel(
        params: BookingNavigationParams,
        getUserAvailableDaysUseCase: GetUserAvailableDaysUseCase,
        getUserAvailableTimeslotsUseCase: GetUserAvailableTimeslotsUseCase,
        createScrollBookerAppointmentUseCase: CreateScrollBookerAppointmentUseCase
    ) -> BookingViewModel {
        BookingViewModel(
            params: params,
            getBookingFlowUseCase: getBookingFlowUseCase,
            getUserAvailableDaysUseCase: getUserAvailableDaysUseCase,
            getUserAvailableTimeslotsUseCase: getUserAvailableTimeslotsUseCase,
            createScrollBookerAppointmentUseCase: createScrollBookerAppointmentUseCase
        )
    }
}
