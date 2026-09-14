//
//  CommentsViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.07.2026.
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class CommentsViewModel {
    private(set) var viewState: FeatureState<[CommentUIItem]> = .idle
    private(set) var isPaging: Bool = false
    private(set) var isSendingComment: Bool = false
    var operationErrorMessage: String?

    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "Comments")

    private let postId: Int
    private let createCommentUseCase: CreateCommentUseCase
    private let getPostCommentsUseCase: GetPostCommentsUseCase
    private let likeCommentUseCase: LikeCommentUseCase
    private let unlikeCommentUseCase: UnlikeCommentUseCase
    private let getCommentRepliesUseCase: GetCommentRepliesUseCase

    private var page = 1
    private let limit = 20
    private var totalCount = 0

    private let repliesLimit = 10

    var replyingToUsername: String? = nil

    var inputPlaceholder: String {
        if let username = replyingToUsername {
            return "Răspunde-i lui @\(username)..."
        }
        return "Adaugă un comentariu..."
    }

    var hasMore: Bool {
        guard let currentCount = viewState.data?.count else { return false }
        return currentCount < totalCount
    }

    init(
        postId: Int,
        getPostCommentsUseCase: GetPostCommentsUseCase,
        createCommentUseCase: CreateCommentUseCase,
        likeCommentUseCase: LikeCommentUseCase,
        unlikeCommentUseCase: UnlikeCommentUseCase,
        getCommentRepliesUseCase: GetCommentRepliesUseCase
    ) {
        self.postId = postId
        self.getPostCommentsUseCase = getPostCommentsUseCase
        self.createCommentUseCase = createCommentUseCase
        self.likeCommentUseCase = likeCommentUseCase
        self.unlikeCommentUseCase = unlikeCommentUseCase
        self.getCommentRepliesUseCase = getCommentRepliesUseCase
    }

    func loadComments() async {
        guard viewState.data == nil else { return }
        guard viewState != .loading else { return }

        page = 1
        await fetch(isFirstPage: true)
    }

    func loadMoreIfNeeded(currentItem: CommentUIItem?) async {
        guard let items = viewState.data, !items.isEmpty else { return }
        guard hasMore, !isPaging, viewState != .loading, !isSendingComment else { return }

        guard let current = currentItem,
              current.id == items.last?.id
        else { return }

        isPaging = true
        await fetch(isFirstPage: false)
        isPaging = false
    }

    private func fetch(isFirstPage: Bool) async {
        if isFirstPage && viewState.data != nil {
            return
        }

        if isFirstPage {
            viewState = .loading
            operationErrorMessage = nil
        }

        do {
            let response: PaginatedResponse<Comment>
            if isFirstPage {
                response = try await withLoading {
                    try await getPostCommentsUseCase(
                        postId: postId,
                        page: page,
                        limit: limit
                    )
                }
            } else {
                response = try await getPostCommentsUseCase(
                    postId: postId,
                    page: page,
                    limit: limit
                )
            }

            let newItems = response.results.map { CommentUIItem(comment: $0) }

            if isFirstPage {
                viewState = .success(newItems)
            } else {
                let currentItems = viewState.data ?? []
                let existingIds = Set(currentItems.map(\.id))
                let uniqueNewItems = newItems.filter { !existingIds.contains($0.id) }
                viewState = .success(currentItems + uniqueNewItems)
            }

            totalCount = response.count
            page += 1

        } catch {
            let message = logger.userMessage(for: error, context: "Loading Comments (FirstPage: \(isFirstPage))")

            if isFirstPage {
                viewState = .error(message)
            } else {
                operationErrorMessage = message
            }
        }
    }

    func sendComment(text: String, parentId: Int?, replyToCommentId: Int?) async {
        let cleanedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanedText.isEmpty else { return }

        operationErrorMessage = nil
        isSendingComment = true

        do {
            let realComment = try await createCommentUseCase(
                postId: postId,
                text: cleanedText,
                parentId: parentId,
                replyToCommentId: replyToCommentId
            )

            if let rootId = parentId {
                appendReply(realComment, toParent: rootId)
            } else {
                let currentItems = viewState.data ?? []
                viewState = .success([CommentUIItem(comment: realComment)] + currentItems)
                totalCount += 1
            }

            replyingToUsername = nil
            isSendingComment = false
        } catch {
            operationErrorMessage = logger.userMessage(for: error, context: "Sending Comment")
            isSendingComment = false
        }
    }

    private func appendReply(_ reply: Comment, toParent parentId: Int) {
        let replyItem = CommentUIItem(comment: reply)

        mutateItem(id: parentId) { parent in
            switch parent.repliesState {
            case .loaded(let replies, let nextPage, let total):
                parent.repliesState = .loaded(replies: replies + [replyItem], nextPage: nextPage, totalCount: total + 1)
            case .notLoaded, .loading:
                parent.repliesState = .loaded(replies: [replyItem], nextPage: 1, totalCount: parent.repliesCount + 1)
            }
            parent.comment = parent.comment.copy(repliesCount: parent.repliesCount + 1)
        }
    }

    func toggleLikeComment(for commentId: Int) async {
        guard let items = viewState.data,
              let target = findItem(id: commentId, in: items) else { return }

        guard !target.isLikeActionPending else { return }

        let originalIsLiked = target.isLiked
        let originalLikeCount = target.likeCount
        let nextIsLiked = !originalIsLiked
        let nextLikeCount = nextIsLiked ? target.likeCount + 1 : max(0, target.likeCount - 1)

        mutateItem(id: commentId) { item in
            item.comment = item.comment.copy(likeCount: nextLikeCount, isLiked: nextIsLiked)
            item.isLikeActionPending = true
        }

        do {
            if originalIsLiked {
                _ = try await unlikeCommentUseCase(commentId: commentId)
            } else {
                _ = try await likeCommentUseCase(commentId: commentId)
            }

            mutateItem(id: commentId) { $0.isLikeActionPending = false }

        } catch {
            mutateItem(id: commentId) { item in
                item.comment = item.comment.copy(likeCount: originalLikeCount, isLiked: originalIsLiked)
                item.isLikeActionPending = false
            }
            operationErrorMessage = logger.userMessage(for: error, context: "Toggling Like for Comment \(commentId)")
        }
    }

    func loadReplies(for parentId: Int) async {
        guard let items = viewState.data,
              let parent = items.first(where: { $0.id == parentId }),
              !parent.repliesState.isLoading else { return }

        let currentPage = parent.repliesState.currentPage
        let isFirstPage = currentPage == 1
        let existingReplies = parent.repliesState.loadedReplies

        mutateItem(id: parentId) { $0.repliesState = .loading }

        do {
            let response = try await getCommentRepliesUseCase(
                postId: postId,
                parentId: parentId,
                page: currentPage,
                limit: repliesLimit
            )

            let fetchedReplies = response.results.map { CommentUIItem(comment: $0) }
            let mergedReplies: [CommentUIItem]
            if isFirstPage {
                mergedReplies = fetchedReplies
            } else {
                let existingIds = Set(existingReplies.map(\.id))
                mergedReplies = existingReplies + fetchedReplies.filter { !existingIds.contains($0.id) }
            }

            mutateItem(id: parentId) { item in
                item.repliesState = .loaded(replies: mergedReplies, nextPage: currentPage + 1, totalCount: response.count)
                item.comment = item.comment.copy(repliesCount: response.count)
            }

        } catch {
            mutateItem(id: parentId) { item in
                item.repliesState = isFirstPage
                    ? .notLoaded
                    : .loaded(replies: existingReplies, nextPage: currentPage, totalCount: item.repliesCount)
            }
            logger.error("ERROR: on Loading Replies for \(parentId): \(error.localizedDescription, privacy: .public)")
        }
    }

    private func mutateItem(id: Int, _ transform: (inout CommentUIItem) -> Void) {
        guard var items = viewState.data else { return }

        if let index = items.firstIndex(where: { $0.id == id }) {
            transform(&items[index])
            viewState = .success(items)
            return
        }

        for parentIndex in items.indices {
            guard case .loaded(var replies, let nextPage, let total) = items[parentIndex].repliesState,
                  let replyIndex = replies.firstIndex(where: { $0.id == id }) else { continue }

            transform(&replies[replyIndex])
            items[parentIndex].repliesState = .loaded(replies: replies, nextPage: nextPage, totalCount: total)
            viewState = .success(items)
            return
        }
    }

    private func findItem(id: Int, in items: [CommentUIItem]) -> CommentUIItem? {
        if let found = items.first(where: { $0.id == id }) { return found }
        for item in items {
            if let found = item.repliesState.loadedReplies.first(where: { $0.id == id }) {
                return found
            }
        }
        return nil
    }
}
