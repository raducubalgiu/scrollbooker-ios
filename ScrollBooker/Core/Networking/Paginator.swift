//
//  Paginator.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 01.08.2026.
//

import Foundation
import Observation
import OSLog

enum PagingFeatureState<Item: Equatable>: Equatable {
    case idle
    case loading
    case error(String)
    case success([Item])

    var data: [Item]? {
        if case .success(let items) = self { return items }
        return nil
    }
}

@Observable
@MainActor
final class Paginator<Item: Identifiable & Equatable> {
    private(set) var viewState: PagingFeatureState<Item> = .idle
    private(set) var isPaging: Bool = false
    var isRefreshing: Bool = false

    private let limit: Int
    private var page = 1
    private var totalCount = 0
    private let fetch: (_ page: Int, _ limit: Int) async throws -> PaginatedResponse<Item>
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "Paginator")

    var hasMore: Bool {
        let currentCount = viewState.data?.count ?? 0
        return currentCount < totalCount
    }

    init(
        limit: Int = 20,
        fetch: @escaping (_ page: Int, _ limit: Int) async throws -> PaginatedResponse<Item>
    ) {
        self.limit = limit
        self.fetch = fetch
    }

    func loadInitialIfNeeded() async {
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

    func loadMoreIfNeeded(currentItem: Item?) async {
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
            let response = try await fetch(page, limit)
            let existingData = viewState.data ?? []
            let newData: [Item]

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
            logger.error("ERROR: Paginator load (FirstPage: \(isFirstPage)): \(error.localizedDescription)")
            
            if isFirstPage {
                viewState = .error("Something went wrong")
            }
        }
    }
}
