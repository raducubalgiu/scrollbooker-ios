//
//  PostViewHeartbeatTracker.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.10.2026.
//

import Combine
import Foundation
import UIKit

@Observable
@MainActor
final class PostViewHeartbeatTracker {
    private struct ViewSession {
        let sessionId: String
        let postId: Int
        let scopeKey: String
        let mediaDurationMs: Int?
        var lastKnownPositionMs: Int
        var lastResumeAt: Date
    }

    private static let heartbeatIntervalSeconds: Double = 5
    private static let flushIntervalSeconds: Double = 15
    private static let forceFlushThreshold = 30
    private static let maxBufferedEvents = 200
    private static let maxEventsPerBatch = 50
    private static let maxDeltaMs = 60_000

    /// Keyed `"scopeKey#postId"` — not bare post id like Android's `_userPausedPostIds`-adjacent
    /// session map. iOS keeps Explore/Following alive simultaneously for the app's lifetime, so
    /// the same post id could plausibly be "current" in two scopes at once (a video review can
    /// also surface in Explore); scoping the key avoids one scope's playback corrupting another
    /// scope's accumulated watch time. Same reasoning already applied to `VideoPlayerManager`'s
    /// `userPausedKeys`.
    private var sessions: [String: ViewSession] = [:]
    private var heartbeatTasks: [String: Task<Void, Never>] = [:]
    private var pendingEvents: [PostViewEventBulkItem] = []
    private var isFlushing = false
    private var flushLoopTask: Task<Void, Never>?
    private var cancellables: Set<AnyCancellable> = []

    private let createPostViewEventsBulkUseCase: CreatePostViewEventsBulkUseCase

    init(videoPlayerManager: VideoPlayerManager, createPostViewEventsBulkUseCase: CreatePostViewEventsBulkUseCase) {
        self.createPostViewEventsBulkUseCase = createPostViewEventsBulkUseCase

        videoPlayerManager.playbackEvents
            .sink { [weak self] event in
                self?.handle(event)
            }
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)
            .sink { [weak self] _ in
                Task { await self?.flushNow() }
            }
            .store(in: &cancellables)

        startFlushLoop()
    }

    private func startFlushLoop() {
        flushLoopTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(Self.flushIntervalSeconds))
                guard let self else { return }
                await self.flushNow()
            }
        }
    }

    private func handle(_ event: PlaybackEvent) {
        let key = "\(event.scopeKey)#\(event.postId)"

        if event.isPlaying {
            startOrResumeSession(key: key, event: event)
        } else {
            endSession(key: key, event: event)
        }
    }

    private func startOrResumeSession(key: String, event: PlaybackEvent) {
        heartbeatTasks[key]?.cancel()

        if var existing = sessions[key] {
            existing.lastResumeAt = Date()
            existing.lastKnownPositionMs = event.positionMs
            sessions[key] = existing
        } else {
            sessions[key] = ViewSession(
                sessionId: UUID().uuidString,
                postId: event.postId,
                scopeKey: event.scopeKey,
                mediaDurationMs: event.durationMs,
                lastKnownPositionMs: event.positionMs,
                lastResumeAt: Date()
            )
        }

        heartbeatTasks[key] = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(Self.heartbeatIntervalSeconds))
                guard let self, !Task.isCancelled else { return }
                self.emitHeartbeat(forKey: key)
            }
        }
    }

    private func endSession(key: String, event: PlaybackEvent) {
        heartbeatTasks[key]?.cancel()
        heartbeatTasks.removeValue(forKey: key)

        guard let session = sessions.removeValue(forKey: key) else { return }
        let deltaMs = elapsedMs(since: session.lastResumeAt)

        guard deltaMs > 0 else { return }
        enqueueEvent(
            postId: session.postId,
            scopeKey: session.scopeKey,
            sessionId: session.sessionId,
            watchedMsDelta: deltaMs,
            positionMs: event.positionMs,
            mediaDurationMs: session.mediaDurationMs
        )
    }

    private func emitHeartbeat(forKey key: String) {
        guard var session = sessions[key] else { return }
        let deltaMs = elapsedMs(since: session.lastResumeAt)
        session.lastResumeAt = Date()
        sessions[key] = session

        guard deltaMs > 0 else { return }
        enqueueEvent(
            postId: session.postId,
            scopeKey: session.scopeKey,
            sessionId: session.sessionId,
            watchedMsDelta: deltaMs,
            positionMs: session.lastKnownPositionMs,
            mediaDurationMs: session.mediaDurationMs
        )
    }

    private func elapsedMs(since date: Date) -> Int {
        let deltaMs = Int(Date().timeIntervalSince(date) * 1000)
        return min(max(deltaMs, 0), Self.maxDeltaMs)
    }

    private func enqueueEvent(
        postId: Int,
        scopeKey: String,
        sessionId: String,
        watchedMsDelta: Int,
        positionMs: Int,
        mediaDurationMs: Int?
    ) {
        let item = PostViewEventBulkItem(
            eventId: UUID().uuidString,
            postId: postId,
            sessionId: sessionId,
            source: source(forScopeKey: scopeKey),
            platform: .ios,
            watchedMsDelta: watchedMsDelta,
            positionMs: positionMs,
            mediaDurationMs: mediaDurationMs,
            capturedAt: Int(Date().timeIntervalSince1970 * 1000),
            viewerFingerprintHash: nil
        )

        pendingEvents.append(item)

        if pendingEvents.count > Self.maxBufferedEvents {
            pendingEvents.removeFirst(pendingEvents.count - Self.maxBufferedEvents)
        }

        if pendingEvents.count >= Self.forceFlushThreshold {
            Task { await self.flushNow() }
        }
    }

    func flushNow() async {
        guard !isFlushing, !pendingEvents.isEmpty else { return }
        isFlushing = true
        defer { isFlushing = false }

        while !pendingEvents.isEmpty {
            let batch = Array(pendingEvents.prefix(Self.maxEventsPerBatch))
            let request = PostViewEventsBulkRequest(events: batch, clientBatchId: UUID().uuidString)

            do {
                _ = try await createPostViewEventsBulkUseCase(request: request)
                pendingEvents.removeFirst(batch.count)
            } catch {
                if case APIError.server(let status, _) = error, status == 401 {
                    pendingEvents.removeFirst(batch.count)
                }
                break
            }
        }
    }

    /// iOS's own scope-key strings, mapped to the same `PostViewSourceEnum` the backend already
    /// defines. Deliberately maps `review_detail_*` to `.videoReviews` — Android's equivalent
    /// mapping has no case for it at all and silently falls through to `OTHER`, which isn't
    /// replicated here.
    private func source(forScopeKey scopeKey: String) -> PostViewSourceEnum {
        if scopeKey == "explore_feed" { return .exploreFeed }
        if scopeKey == "following_feed" { return .followingFeed }
        if scopeKey.hasPrefix("USER_PROFILE_DETAIL_POSTS_") { return .postDetail }
        if scopeKey.hasPrefix("USER_PROFILE_DETAIL_BOOKMARKS_") { return .bookmarkPostDetail }
        if scopeKey.hasPrefix("review_detail_") { return .videoReviews }
        return .other
    }
}
