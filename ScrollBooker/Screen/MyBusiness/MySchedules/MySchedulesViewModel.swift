//
//  MySchedulesViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

import Foundation
import Observation

enum MySchedulesState: Equatable {
    case idle
    case loading
    case success([Schedule])
    case error(String)
}

@Observable
@MainActor
final class MySchedulesViewModel: HasLoadingState {
    var uiState = UiState(data: [Schedule]())
    private(set) var viewState: MySchedulesState = .idle
    var isSaving: Bool = false
    
    private let session: SessionManager
    private let getSchedulesByUserIdUseCase: GetSchedulesByUserIdUseCase
    private let updateSchedulesUseCase: UpdateSchedulesUseCase
    
    var isLoading: Bool {
        get { if case .loading = viewState { return true }; return uiState.isLoading }
        set { uiState.isLoading = newValue }
    }

    var errorMessage: String? {
        get { if case .error(let msg) = viewState { return msg }; return uiState.errorMessage }
        set { uiState.errorMessage = newValue }
    }
    
    init(session: SessionManager, getSchedulesByUserIdUseCase: GetSchedulesByUserIdUseCase, updateSchedulesUseCase: UpdateSchedulesUseCase) {
        self.session = session
        self.getSchedulesByUserIdUseCase = getSchedulesByUserIdUseCase
        self.updateSchedulesUseCase = updateSchedulesUseCase
    }
    
    func loadSchedules() async {
        guard uiState.data.isEmpty else { return }
        guard viewState != .loading else { return }
        
        viewState = .loading
        uiState.errorMessage = nil
        
        guard let userId = session.userInfo?.id else {
            viewState = .error("User ID not found in session")
            return
        }
        
        do {
            let data = try await withVisibleLoading {
                try await getSchedulesByUserIdUseCase(userId: userId)
            }
            
            self.uiState.data = data
            self.viewState = .success(data)
        } catch {
            viewState = .error(error.localizedDescription)
        }
    }
    
    func updateLocalScheduleRow(updatedSchedule: Schedule) {
        if let index = uiState.data.firstIndex(where: { $0.id == updatedSchedule.id }) {
            uiState.data[index] = updatedSchedule
            viewState = .success(uiState.data)
        }
    }
    
    func saveSchedules() async {
        guard !isSaving else { return }
        isSaving = true
        uiState.errorMessage = nil
        
        do {
            let updatedData = try await withVisibleLoading {
                try await updateSchedulesUseCase(schedules: uiState.data)
            }
            
            self.uiState.data = updatedData
            self.viewState = .success(updatedData)
            isSaving = false
        } catch {
            uiState.errorMessage = error.localizedDescription
            isSaving = false
        }
    }
}
