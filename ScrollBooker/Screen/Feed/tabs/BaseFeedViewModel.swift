//
//  BaseFeedViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 23.07.2026.
//

import Observation
import AVKit

enum FeedPostsState {
    case idle
    case loading
    case empty
    case success([Post])
    case error(String)
}

@Observable
class BaseFeedViewModel {
    private(set) var posts: [Post] = []
    var players: [String: AVPlayer] = [:]
    var currentIndex: Int = 0
    
    private(set) var viewState: FeedPostsState = .idle
    private(set) var isPaging: Bool = false
    private(set) var isRefreshing: Bool = false

    private var page = 1
    private let limit = 10
    private var totalCount = 0

    var hasMore: Bool {
        posts.count < totalCount
    }

    var isLoading: Bool {
        get { if case .loading = viewState { return true }; return false }
        set { if newValue { viewState = .loading } }
    }

    func initialLoadIfNeeded(fetchBlock: (_ page: Int, _ limit: Int) async throws -> PaginatedResponse<Post>) async {
        guard posts.isEmpty else { return }
        await load(isFirstPage: true, fetchBlock: fetchBlock)
    }

    func refresh(fetchBlock: (_ page: Int, _ limit: Int) async throws -> PaginatedResponse<Post>) async {
        guard !isRefreshing else { return }
        isRefreshing = true
        page = 1
        await load(isFirstPage: true, fetchBlock: fetchBlock)
        isRefreshing = false
    }

    func loadMoreIfNeeded(currentPost: Post?, fetchBlock: (_ page: Int, _ limit: Int) async throws -> PaginatedResponse<Post>) async {
        guard hasMore, !isPaging, !isRefreshing, !isLoading else { return }
        
        guard let current = currentPost,
              current.id == posts.last?.id
        else { return }

        isPaging = true
        await load(isFirstPage: false, fetchBlock: fetchBlock)
        isPaging = false
    }

    @MainActor
    private func load(isFirstPage: Bool, fetchBlock: (_ page: Int, _ limit: Int) async throws -> PaginatedResponse<Post>) async {
        if isFirstPage && !isRefreshing {
            viewState = .loading
        }

        do {
            let response = try await fetchBlock(page, limit)

            if isFirstPage {
                posts = response.results
            } else {
                let existingIds = Set(posts.map(\.id))
                let unique = response.results.filter { !existingIds.contains($0.id) }
                posts.append(contentsOf: unique)
            }

            totalCount = response.count
            page += 1
            
            if posts.isEmpty {
                viewState = .empty
            } else {
                viewState = .success(posts)
            }

        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription

            if isFirstPage {
                viewState = .error(message)
            } else {
                print("Eroare la încărcarea paginii următoare: \(message)")
            }
        }
    }
}
