//
//  MySchedulesViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class MySchedulesViewModel {
    private(set) var viewState: FeatureState<[Schedule]> = .idle
    var isSaving: Bool = false
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "Schedules")
    
    private let session: SessionManager
    private let getSchedulesByUserIdUseCase: GetSchedulesByUserIdUseCase
    private let updateSchedulesUseCase: UpdateSchedulesUseCase
    
    init(
        session: SessionManager,
        getSchedulesByUserIdUseCase: GetSchedulesByUserIdUseCase,
        updateSchedulesUseCase: UpdateSchedulesUseCase
    ) {
        self.session = session
        self.getSchedulesByUserIdUseCase = getSchedulesByUserIdUseCase
        self.updateSchedulesUseCase = updateSchedulesUseCase
    }
    
    func loadSchedules() async {
        guard viewState.data == nil else { return }
        guard viewState != .loading else { return }
        
        viewState = .loading
        
        guard let userId = session.userInfo?.id else {
            logger.error("ERROR: User ID not found in session")
            viewState = .error("Something went wrong")
            return
        }
        
        do {
            let data = try await withLoading {
                try await getSchedulesByUserIdUseCase(userId: userId)
            }
            viewState = .success(data)
        } catch {
            logger.error("ERROR: on Fetching Schedules: \(error.localizedDescription)")
            viewState = .error("Something went wrong")
        }
    }
    
    func updateLocalScheduleRow(updatedSchedule: Schedule) {
        guard var currentSchedules = viewState.data else { return }
        
        if let index = currentSchedules.firstIndex(where: { $0.id == updatedSchedule.id }) {
            currentSchedules[index] = updatedSchedule
            viewState = .success(currentSchedules)
        }
    }
    
    func saveSchedules() async {
        guard let currentSchedules = viewState.data else { return }
        guard !isSaving else { return }
        
        isSaving = true
        
        do {
            let updatedData = try await withLoading {
                try await updateSchedulesUseCase(schedules: currentSchedules)
            }
            viewState = .success(updatedData)
        } catch {
            logger.error("ERROR: on Saving Schedules: \(error.localizedDescription)")
        }
        
        isSaving = false
    }
}

