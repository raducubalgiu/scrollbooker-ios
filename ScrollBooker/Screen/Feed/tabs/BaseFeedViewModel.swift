//
//  BaseFeedViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 23.07.2026.
//

import Observation
import AVKit
import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

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
    
    var players: [Int: AVPlayer] = [:]
    var currentIndex: Int = 0 {
        didSet {
            updateWindow(at: currentIndex)
        }
    }
    
    private(set) var viewState: FeedPostsState = .idle
    private(set) var isPaging: Bool = false
    private(set) var isRefreshing: Bool = false

    private var page = 1
    private let limit = 10
    private var totalCount = 0
    
    var operationErrorMessage: String? = nil

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

    func loadMoreIfNeeded(
        currentPost: Post?,
        fetchBlock: (_ page: Int, _ limit: Int
    ) async throws -> PaginatedResponse<Post>) async {
        guard hasMore, !isPaging, !isRefreshing, !isLoading else { return }
        
        guard let current = currentPost,
              current.id == posts.last?.id
        else { return }

        isPaging = true
        await load(isFirstPage: false, fetchBlock: fetchBlock)
        isPaging = false
    }

    @MainActor
    private func load(
        isFirstPage: Bool,
        fetchBlock: (_ page: Int, _ limit: Int
    ) async throws -> PaginatedResponse<Post>) async {
        
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
    
    @MainActor
    func toggleLike(
        postId: Int,
        likeAction: (Int) async throws -> NoContent,
        unlikeAction: (Int) async throws -> NoContent
    ) async {
        guard let index = posts.firstIndex(where: { $0.id == postId }) else { return }
        
        let originalPost = posts[index]
        let currentlyLiked = originalPost.userActions.isLiked
        
        let newIsLiked = !currentlyLiked
        let newLikeCount = currentlyLiked ? max(0, originalPost.counters.likeCount - 1) : originalPost.counters.likeCount + 1
        
        posts[index] = originalPost.copy(
            counters: originalPost.counters.copy(likeCount: newLikeCount),
            userActions: originalPost.userActions.copy(isLiked: newIsLiked)
        )
        
        operationErrorMessage = nil
        
        do {
            if currentlyLiked {
                _ = try await unlikeAction(postId)
            } else {
                _ = try await likeAction(postId)
            }
        } catch {
            if let currentIndex = posts.firstIndex(where: { $0.id == postId }) {
                posts[currentIndex] = originalPost
            }
            operationErrorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        }
    }
    
    @MainActor
    func toggleBookmark(
        postId: Int,
        bookmarkAction: (Int) async throws -> NoContent,
        unbookmarkAction: (Int) async throws -> NoContent
    ) async {
        guard let index = posts.firstIndex(where: { $0.id == postId }) else { return }
        
        let originalPost = posts[index]
        let currentlyBookmarked = originalPost.userActions.isBookmarked
        
        let newIsBookmarked = !currentlyBookmarked
        
        posts[index] = originalPost.copy(
            userActions: originalPost.userActions.copy(isBookmarked: newIsBookmarked)
        )
        
        operationErrorMessage = nil
        
        do {
            if currentlyBookmarked {
                _ = try await unbookmarkAction(postId)
            } else {
                _ = try await bookmarkAction(postId)
            }
        } catch {
            if let currentIndex = posts.firstIndex(where: { $0.id == postId }) {
                posts[currentIndex] = originalPost
            }
            operationErrorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        }
    }
    
    func updateWindow(at index: Int) {
        guard !posts.isEmpty else { return }
        
        // 1. Extragem direct obiectele Post folosind subscript-ul safe
        let currentPost = posts[safe: index]
        let prevPost = posts[safe: index - 1]
        let nextPost = posts[safe: index + 1]
        
        // 2. Colectăm ID-urile ferestrei active (exact ca înainte)
        let activeIds = Set([prevPost?.id, currentPost?.id, nextPost?.id].compactMap { $0 })
        
        // 3. Eliberăm playerele care nu mai sunt în fereastră
        for (postId, player) in players {
            if !activeIds.contains(postId) {
                player.pause()
                player.replaceCurrentItem(with: nil)
                players.removeValue(forKey: postId)
            }
        }
        
        // 4. Pornim playerul curent folosind obiectul Post direct
        if let current = currentPost {
            let currentPlayer = getOrCreatePlayer(for: current) // <-- Schimbat în obiect Post
            currentPlayer.isMuted = false
            currentPlayer.play()
        }
        
        // 5. Pregătim (buffer) postarea anterioară în mod silențios
        if let prev = prevPost {
            let prevPlayer = getOrCreatePlayer(for: prev)
            prevPlayer.isMuted = true
        }
        
        // 6. Pregătim (buffer) postarea următoare în mod silențios
        if let next = nextPost {
            let nextPlayer = getOrCreatePlayer(for: next)
            nextPlayer.isMuted = true
        }
    }
        
    func playCurrent() {
        guard let currentPostId = posts[safe: currentIndex]?.id,
              let player = players[currentPostId] else { return }
        player.isMuted = false
        player.play()
    }
        
    func pauseAll() {
        for player in players.values {
            player.pause()
        }
    }
        
    private func getOrCreatePlayer(for post: Post) -> AVPlayer { // <-- Acum primește Post
        // Dacă playerul există deja, îl returnăm intact
        if let existingPlayer = players[post.id] {
            return existingPlayer
        }
        
        // Extragere URL din structura ta
        guard let videoUrlString = post.mediaFiles.first?.url,
              let url = URL(string: videoUrlString) else {
            return AVPlayer()
        }
        
        let asset = AVURLAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        
        playerItem.automaticallyPreservesTimeOffsetFromLive = true
        playerItem.preferredForwardBufferDuration = 5
        
        let newPlayer = AVPlayer(playerItem: playerItem)
        newPlayer.actionAtItemEnd = .none
        
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: playerItem,
            queue: .main
        ) { _ in
            newPlayer.seek(to: .zero)
            newPlayer.play()
        }
        
        players[post.id] = newPlayer
        return newPlayer
    }
}
