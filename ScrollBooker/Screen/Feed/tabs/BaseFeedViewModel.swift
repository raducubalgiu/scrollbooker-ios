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
        
        let currentPostId = posts[safe: index]?.id
        let prevPostId = posts[safe: index - 1]?.id
        let nextPostId = posts[safe: index + 1]?.id
        
        let activeIds = Set([prevPostId, currentPostId, nextPostId].compactMap { $0 })
        
        for (postId, player) in players {
            if !activeIds.contains(postId) {
                player.pause()
                player.replaceCurrentItem(with: nil)
                players.removeValue(forKey: postId)
            }
        }
        
        if let currentId = currentPostId {
            let currentPlayer = getOrCreatePlayer(for: index)
            currentPlayer.isMuted = false
            currentPlayer.play()
        }
        
        if let prevId = prevPostId, index - 1 >= 0 {
            let prevPlayer = getOrCreatePlayer(for: index - 1)
            prevPlayer.isMuted = true
        }
        
        if let nextId = nextPostId, index + 1 < posts.count {
            let nextPlayer = getOrCreatePlayer(for: index + 1)
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
        
    private func getOrCreatePlayer(for index: Int) -> AVPlayer {
        let post = posts[index]
        
        // Dacă playerul există deja în fereastră, îl returnăm intact
        if let existingPlayer = players[post.id] {
            return existingPlayer
        }
        
        // Extragere URL valid din structura ta PostMediaFile
        guard let videoUrlString = post.mediaFiles.first?.url,
              let url = URL(string: videoUrlString) else {
            return AVPlayer()
        }
        
        // Configurăm un AVPlayerItem optimizat pentru streaming rapid
        let asset = AVURLAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        
        // Îi spunem sistemului să încarce buffer-ul agresiv în avans
        playerItem.automaticallyPreservesTimeOffsetFromLive = true
        playerItem.preferredForwardBufferDuration = 5
        
        let newPlayer = AVPlayer(playerItem: playerItem)
        newPlayer.actionAtItemEnd = .none // Permite loop-ul infinit nativ ulterior
        
        // Înregistrăm observatorul de loop (când clipul ajunge la final, revine la secunda 0)
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: playerItem,
            queue: .main
        ) { _ in
            newPlayer.seek(to: .zero)
            newPlayer.play()
        }
        
        // Salvăm în dicționarul ferestrei active
        players[post.id] = newPlayer
        return newPlayer
    }
}
