//
//  AppointmentsViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 06.09.2025.
//

import Foundation
import Observation

@Observable
@MainActor
final class AppointmentsViewModel: HasLoadingState {

    var uiState = UiState(data: [Appointment]())

    private let getUserAppointments: GetUserAppointmentsUseCase

    private var page = 1
    private let limit = 20

    private var totalCount = 0
    private var isPaging = false

    var hasMore: Bool {
        uiState.data.count < totalCount
    }

    // MARK: - HasLoadingState conformance (proxy către uiState)

    var isLoading: Bool {
        get { uiState.isLoading }
        set { uiState.isLoading = newValue }
    }

    var errorMessage: String? {
        get { uiState.errorMessage }
        set { uiState.errorMessage = newValue }
    }

    init(getUserAppointments: GetUserAppointmentsUseCase) {
        self.getUserAppointments = getUserAppointments
    }

    func initialLoadIfNeeded() async {

        guard uiState.data.isEmpty else { return }

        await load(isFirstPage: true)
    }

    func refresh() async {

        guard !uiState.isRefreshing else { return }

        uiState.isRefreshing = true
        page = 1

        await load(isFirstPage: true)

        uiState.isRefreshing = false
    }

    func loadMoreIfNeeded(currentAppointment: Appointment?) async {

        guard hasMore else { return }
        guard !uiState.isLoading else { return }
        guard !uiState.isRefreshing else { return }
        guard !isPaging else { return }

        guard let current = currentAppointment,
              current.id == uiState.data.last?.id
        else {
            return
        }

        isPaging = true

        await load(isFirstPage: false)

        isPaging = false
    }

    private func load(isFirstPage: Bool) async {

        if isFirstPage {
            uiState.errorMessage = nil
        }

        do {
            let response: PaginatedResponse<Appointment>

            if isFirstPage {
                response = try await withVisibleLoading {
                    try await getUserAppointments(page: page, limit: limit)
                }
            } else {
                response = try await getUserAppointments(page: page, limit: limit)
            }

            if isFirstPage {

                uiState.data = response.results

            } else {

                let existingIds = Set(uiState.data.map(\.id))

                let unique = response.results.filter {
                    !existingIds.contains($0.id)
                }

                uiState.data.append(contentsOf: unique)

            }

            totalCount = response.count
            page += 1

        } catch {

            let message = (error as? LocalizedError)?
                .errorDescription
                ?? error.localizedDescription

            if isFirstPage {
                uiState.errorMessage = message
            }

        }
    }
}
