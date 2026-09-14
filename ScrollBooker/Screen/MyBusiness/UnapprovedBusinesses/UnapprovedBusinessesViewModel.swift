//
//  UnapprovedBusinessesViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class UnapprovedBusinessesViewModel {
    private(set) var viewState: FeatureState<[UnapprovedBusiness]> = .idle
    private(set) var isPaging: Bool = false
    var isRefreshing: Bool = false

    private(set) var approvingBusinessId: Int?
    var errorMessage: String?

    private let getUnapprovedBusinessesUseCase: GetUnapprovedBusinessesUseCase
    private let approveBusinessUseCase: ApproveBusinessUseCase
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "UnapprovedBusinesses")

    private var page = 1
    private let limit = 20
    private var totalCount = 0

    var hasMore: Bool {
        let currentCount = viewState.data?.count ?? 0
        return currentCount < totalCount
    }

    init(
        getUnapprovedBusinessesUseCase: GetUnapprovedBusinessesUseCase,
        approveBusinessUseCase: ApproveBusinessUseCase
    ) {
        self.getUnapprovedBusinessesUseCase = getUnapprovedBusinessesUseCase
        self.approveBusinessUseCase = approveBusinessUseCase
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

    func loadMoreIfNeeded(currentItem: UnapprovedBusiness?) async {
        let currentData = viewState.data ?? []

        guard hasMore, !isPaging, !isRefreshing, viewState != .loading else { return }

        guard let current = currentItem,
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
            let response = try await withLoading {
                try await getUnapprovedBusinessesUseCase(page: page, limit: limit)
            }
            let existingData = viewState.data ?? []
            let newData: [UnapprovedBusiness]

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
            logger.error("ERROR: on Loading Unapproved Businesses (FirstPage: \(isFirstPage)): \(error.localizedDescription)")

            if isFirstPage {
                viewState = .error("Something went wrong")
            }
        }
    }

    func approveBusiness(userId: Int) async {
        guard approvingBusinessId == nil else { return }

        approvingBusinessId = userId

        do {
            _ = try await withLoading {
                try await approveBusinessUseCase(userId: userId)
            }
            approvingBusinessId = nil
            await refresh()
        } catch {
            logger.error("ERROR: on Approving Business for userId \(userId): \(error.localizedDescription)")
            approvingBusinessId = nil
            errorMessage = "Something went wrong"
        }
    }
}
