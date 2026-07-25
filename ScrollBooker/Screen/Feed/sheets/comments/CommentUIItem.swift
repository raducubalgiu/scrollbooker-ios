//
//  CommentUIItem.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.07.2026.
//

import Foundation

struct CommentUIItem: Identifiable, Equatable {
    var comment: Comment
    var isLikeActionPending: Bool = false
    var repliesState: RepliesLoadState = .notLoaded

    var id: Int { comment.id }
    var user: CommentUser { comment.user }
    var text: String { comment.text }
    var likeCount: Int { comment.likeCount }
    var isLiked: Bool { comment.isLiked }
    var repliesCount: Int { comment.repliesCount }

    var remainingRepliesCount: Int {
        max(0, comment.repliesCount - repliesState.loadedReplies.count)
    }
}

enum RepliesLoadState: Equatable {
    case notLoaded
    case loading
    case loaded(replies: [CommentUIItem], nextPage: Int, totalCount: Int)

    var loadedReplies: [CommentUIItem] {
        if case .loaded(let replies, _, _) = self { return replies }
        return []
    }

    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }

    var currentPage: Int {
        if case .loaded(_, let nextPage, _) = self { return nextPage }
        return 1
    }
}
