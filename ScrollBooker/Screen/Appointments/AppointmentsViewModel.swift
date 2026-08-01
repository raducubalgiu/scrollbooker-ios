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
    let paginator: Paginator<Appointment>

    init(getUserAppointments: GetUserAppointmentsUseCase) {
        self.paginator = Paginator(limit: 20) { page, limit in
            try await getUserAppointments(page: page, limit: limit)
        }
    }

    func initialLoadIfNeeded() async {
        await paginator.loadInitialIfNeeded()
    }

    func refresh() async {
        await paginator.refresh()
    }

    func loadMoreIfNeeded(currentItem: Appointment?) async {
        await paginator.loadMoreIfNeeded(currentItem: currentItem)
    }
}


