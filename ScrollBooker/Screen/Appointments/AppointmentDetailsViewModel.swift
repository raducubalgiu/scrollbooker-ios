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
    
    private let session: SessionManager
    private let appointmentId: Int
    private let getAppointmentById: GetAppointmentByIdUseCase
    private let cancelAppointment: CancelAppointmentUseCase
    
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
    
    init(
        session: SessionManager,
        appointmentId: Int,
        getAppointmentById: GetAppointmentByIdUseCase,
        cancelAppointment: CancelAppointmentUseCase
    ) {
        self.session = session
        self.appointmentId = appointmentId
        self.getAppointmentById = getAppointmentById
        self.cancelAppointment = cancelAppointment
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
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
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
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            uiState.errorMessage = message
        }
        uiState.isRefreshing = false
    }
    
    func cancelCurrentAppointment(reason: String) async {
        uiState.errorMessage = nil
        
        do {
            guard let userId = session.userInfo?.id else {
                uiState.errorMessage = "User session not found"
                return
            }
            
            let updatedAppointment = try await withVisibleLoading {
                try await cancelAppointment(
                    id: appointmentId,
                    canceledReason: reason,
                    canceledByUserId: userId
                )
            }
            
            uiState.data = updatedAppointment
            
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            uiState.errorMessage = message
        }
    }
}
