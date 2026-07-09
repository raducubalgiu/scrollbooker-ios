//
//  AppointmentDetailsViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.07.2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class AppointmentDetailsViewModel: HasLoadingState {
    var uiState = UiState(data: Appointment?.none)
    
    private let getAppointmentById: GetAppointmentByIdUseCase
    private let appointmentId: Int
    
    var isFinished: Bool {
        uiState.data?.status == .finished
    }
    
    var isLoading: Bool {
        get { uiState.isLoading }
        set { uiState.isLoading = newValue }
    }
    
    var errorMessage: String? {
        get { uiState.errorMessage }
        set { uiState.errorMessage = newValue }
    }
    
    init(appointmentId: Int, getAppointmentById: GetAppointmentByIdUseCase) {
        self.appointmentId = appointmentId
        self.getAppointmentById = getAppointmentById
    }
    
    func loadAppointment() async {
        guard uiState.data == nil else { return }
        
        uiState.errorMessage = nil
        
        do {
            let result = try await withVisibleLoading {
                try await getAppointmentById(id: appointmentId)
            }
            
            uiState.data = result
            
        } catch {
            let message = (error as? LocalizedError)?.errorDescription
                ?? error.localizedDescription
            
            uiState.errorMessage = message
        }
    }
    
    func refresh() async {
        guard !uiState.isRefreshing else { return }
        
        uiState.isRefreshing = true
        uiState.errorMessage = nil
        
        do {
            let result = try await getAppointmentById(id: appointmentId)
            uiState.data = result
        } catch {
            let message = (error as? LocalizedError)?.errorDescription
                ?? error.localizedDescription
            
            uiState.errorMessage = message
        }
        
        uiState.isRefreshing = false
    }
}
