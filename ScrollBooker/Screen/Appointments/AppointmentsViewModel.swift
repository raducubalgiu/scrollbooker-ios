//
//  AppointmentsViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 06.09.2025.
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class AppointmentsViewModel {
    private(set) var viewState: FeatureState<[Appointment]> = .idle
    private(set) var isPaging: Bool = false
    var isRefreshing: Bool = false

    private let getUserAppointments: GetUserAppointmentsUseCase
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "AppointmentsList")
    
    private var page = 1
    private let limit = 20
    private var totalCount = 0

    var hasMore: Bool {
        let currentCount = viewState.data?.count ?? 0
        return currentCount < totalCount
    }

    init(getUserAppointments: GetUserAppointmentsUseCase) {
        self.getUserAppointments = getUserAppointments
    }

    func initialLoadIfNeeded() async {
        guard viewState.data == nil else { return }
        await load(isFirstPage: true)
    }

    func refresh() async {
        guard !isRefreshing else { return }
        isRefreshing = true
        page = 1
        
        await load(isFirstPage: true)
        
        isRefreshing = false
    }

    func loadMoreIfNeeded(currentAppointment: Appointment?) async {
        let currentData = viewState.data ?? []
        
        guard hasMore, !isPaging, !isRefreshing, viewState != .loading else { return }
        
        guard let current = currentAppointment,
              current.id == currentData.last?.id
        else { return }

        isPaging = true
        await load(isFirstPage: false)
        isPaging = false
    }

    private func load(isFirstPage: Bool) async {
        if isFirstPage && !isRefreshing {
            viewState = .loading
        }

        do {
            let response = try await getUserAppointments(page: page, limit: limit)
            let existingData = viewState.data ?? []
            let newData: [Appointment]

            if isFirstPage {
                newData = response.results
            } else {
                let existingIds = Set(existingData.map(\.id))
                let uniqueItems = response.results.filter { !existingIds.contains($0.id) }
                newData = existingData + uniqueItems
            }

            totalCount = response.count
            page += 1

            viewState = .success(newData)

        } catch {
            logger.error("ERROR: on Loading Appointments (FirstPage: \(isFirstPage)): \(error.localizedDescription)")
            if isFirstPage {
                viewState = .error("Something went wrong")
            }
        }
    }
}

