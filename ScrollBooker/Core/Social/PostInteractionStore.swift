//
//  PostInteractionStore.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.10.2026.
//

import Foundation
import Observation

struct PostInteractionState: Equatable {
    var isLiked: Bool?
    var isBookmarked: Bool?
    var likeCountDelta: Int = 0
    var bookmarkCountDelta: Int = 0
    var shareCount: Int = 0
    var isSavingLike = false
    var isSavingBookmark = false
    var isSavingShare = false

    static let empty = PostInteractionState()
}

@Observable
@MainActor
final class PostInteractionStore {
    private(set) var states: [Int: PostInteractionState] = [:]
    private(set) var followOverrides: [Int: Bool] = [:]

    private let likePostUseCase: LikePostUseCase
    private let unlikePostUseCase: UnlikePostUseCase
    private let bookmarkPostUseCase: BookmarkPostUseCase
    private let unbookmarkPostUseCase: UnbookmarkPostUseCase
    private let followUserUseCase: FollowUserUseCase
    private let unfollowUserUseCase: UnfollowUserUseCase
    private let sharePostUseCase: SharePostUseCase

    init(
        likePostUseCase: LikePostUseCase,
        unlikePostUseCase: UnlikePostUseCase,
        bookmarkPostUseCase: BookmarkPostUseCase,
        unbookmarkPostUseCase: UnbookmarkPostUseCase,
        followUserUseCase: FollowUserUseCase,
        unfollowUserUseCase: UnfollowUserUseCase,
        sharePostUseCase: SharePostUseCase
    ) {
        self.likePostUseCase = likePostUseCase
        self.unlikePostUseCase = unlikePostUseCase
        self.bookmarkPostUseCase = bookmarkPostUseCase
        self.unbookmarkPostUseCase = unbookmarkPostUseCase
        self.followUserUseCase = followUserUseCase
        self.unfollowUserUseCase = unfollowUserUseCase
        self.sharePostUseCase = sharePostUseCase
    }

    func state(for postId: Int) -> PostInteractionState {
        states[postId] ?? .empty
    }

    func isFollowing(userId: Int, fallback: Bool) -> Bool {
        followOverrides[userId] ?? fallback
    }

    func toggleLike(postId: Int, currentlyLiked: Bool) async {
        var optimistic = state(for: postId)
        optimistic.isLiked = !currentlyLiked
        optimistic.likeCountDelta += currentlyLiked ? -1 : 1
        optimistic.isSavingLike = true
        states[postId] = optimistic

        do {
            if currentlyLiked {
                _ = try await unlikePostUseCase(id: postId)
            } else {
                _ = try await likePostUseCase(id: postId)
            }
            states[postId]?.isSavingLike = false
        } catch {
            var reverted = state(for: postId)
            reverted.isLiked = currentlyLiked
            reverted.likeCountDelta = 0
            reverted.isSavingLike = false
            states[postId] = reverted
        }
    }

    func toggleBookmark(postId: Int, currentlyBookmarked: Bool) async {
        var optimistic = state(for: postId)
        optimistic.isBookmarked = !currentlyBookmarked
        optimistic.bookmarkCountDelta += currentlyBookmarked ? -1 : 1
        optimistic.isSavingBookmark = true
        states[postId] = optimistic

        do {
            if currentlyBookmarked {
                _ = try await unbookmarkPostUseCase(id: postId)
            } else {
                _ = try await bookmarkPostUseCase(id: postId)
            }
            states[postId]?.isSavingBookmark = false
        } catch {
            var reverted = state(for: postId)
            reverted.isBookmarked = currentlyBookmarked
            reverted.bookmarkCountDelta = 0
            reverted.isSavingBookmark = false
            states[postId] = reverted
        }
    }

    func toggleFollow(userId: Int, currentlyFollowing: Bool) async {
        followOverrides[userId] = !currentlyFollowing

        do {
            if currentlyFollowing {
                _ = try await unfollowUserUseCase(followeeId: userId)
            } else {
                _ = try await followUserUseCase(followeeId: userId)
            }
        } catch {
            followOverrides[userId] = currentlyFollowing
        }
    }

    func sharePost(postId: Int, channel: ShareChannelEnum) async {
        var saving = state(for: postId)
        saving.isSavingShare = true
        states[postId] = saving

        do {
            _ = try await sharePostUseCase(id: postId, channel: channel)
            var updated = state(for: postId)
            updated.shareCount += 1
            updated.isSavingShare = false
            states[postId] = updated
        } catch {
            states[postId]?.isSavingShare = false
        }
    }
}
