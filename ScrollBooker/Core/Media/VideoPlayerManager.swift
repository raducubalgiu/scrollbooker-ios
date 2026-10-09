//
//  VideoPlayerManager.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.10.2026.
//

import AVKit
import Foundation
import Observation

@Observable
@MainActor
final class VideoPlayerManager {
    private var playersByKey: [String: AVPlayer] = [:]
    private var itemReadyObservations: [String: NSKeyValueObservation] = [:]
    private var loopObservers: [String: NSObjectProtocol] = [:]
    private var signaledScopes: Set<String> = []
    private(set) var readyKeys: Set<String> = []

    private func makeKey(scopeKey: String, postId: Int) -> String {
        "\(scopeKey)#\(postId)"
    }

    private func postId(fromKey key: String) -> Int? {
        key.split(separator: "#").last.flatMap { Int($0) }
    }

    @discardableResult
    func player(
        scopeKey: String,
        post: Post,
        onFirstReady: (() -> Void)? = nil
    ) -> AVPlayer {
        let key = makeKey(scopeKey: scopeKey, postId: post.id)

        if let existing = playersByKey[key] {
            return existing
        }

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

        itemReadyObservations[key] = playerItem.observe(\.status, options: [.new]) { [weak self] item, _ in
            guard let self else { return }
            guard item.status == .readyToPlay || item.status == .failed else { return }

            self.readyKeys.insert(key)

            guard let onFirstReady, !self.signaledScopes.contains(scopeKey) else { return }
            self.signaledScopes.insert(scopeKey)
            DispatchQueue.main.async {
                onFirstReady()
            }
        }

        loopObservers[key] = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: playerItem,
            queue: .main
        ) { _ in
            newPlayer.seek(to: .zero)
            newPlayer.play()
        }

        playersByKey[key] = newPlayer
        return newPlayer
    }

    func existingPlayer(scopeKey: String, postId: Int) -> AVPlayer? {
        playersByKey[makeKey(scopeKey: scopeKey, postId: postId)]
    }

    func isReady(scopeKey: String, postId: Int) -> Bool {
        readyKeys.contains(makeKey(scopeKey: scopeKey, postId: postId))
    }

    func ensureWindow(
        scopeKey: String,
        posts: [Post],
        centerIndex: Int,
        onFirstReady: (() -> Void)? = nil
    ) {
        guard !posts.isEmpty else { return }

        let currentPost = posts[safe: centerIndex]
        let prevPost = posts[safe: centerIndex - 1]
        let nextPost = posts[safe: centerIndex + 1]

        let activeIds = Set([prevPost?.id, currentPost?.id, nextPost?.id].compactMap { $0 })

        for key in playersByKey.keys where key.hasPrefix("\(scopeKey)#") {
            if let id = postId(fromKey: key), !activeIds.contains(id) {
                release(key: key)
            }
        }

        if let current = currentPost {
            let currentPlayer = player(scopeKey: scopeKey, post: current, onFirstReady: onFirstReady)
            currentPlayer.isMuted = false
            currentPlayer.play()
        }

        if let prev = prevPost {
            player(scopeKey: scopeKey, post: prev, onFirstReady: onFirstReady).isMuted = true
        }

        if let next = nextPost {
            player(scopeKey: scopeKey, post: next, onFirstReady: onFirstReady).isMuted = true
        }
    }

    func playCurrent(scopeKey: String, postId: Int) {
        guard let player = playersByKey[makeKey(scopeKey: scopeKey, postId: postId)] else { return }
        player.isMuted = false
        player.play()
    }

    func pauseAll(scopeKey: String) {
        for (key, player) in playersByKey where key.hasPrefix("\(scopeKey)#") {
            player.pause()
        }
    }

    func activateScope(_ scopeKey: String) {
        for (key, player) in playersByKey where !key.hasPrefix("\(scopeKey)#") {
            player.pause()
        }
    }

    func releaseScope(_ scopeKey: String) {
        for key in playersByKey.keys where key.hasPrefix("\(scopeKey)#") {
            release(key: key)
        }
        signaledScopes.remove(scopeKey)
    }

    private func release(key: String) {
        playersByKey[key]?.pause()
        playersByKey[key]?.replaceCurrentItem(with: nil)
        playersByKey.removeValue(forKey: key)
        itemReadyObservations.removeValue(forKey: key)
        readyKeys.remove(key)

        if let observer = loopObservers.removeValue(forKey: key) {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}
