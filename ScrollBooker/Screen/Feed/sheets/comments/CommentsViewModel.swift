//
//  CommentsViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.07.2026.
//

import Foundation
import Observation

enum CommentsState: Equatable {
    case idle
    case loading
    case success([Comment])
    case error(String)
    
    var comments: [Comment]? {
        if case .success(let comments) = self { return comments }
        return nil
    }
}

@Observable
@MainActor
final class CommentsViewModel: HasLoadingState {
    private(set) var viewState: CommentsState = .idle
    private(set) var isPaging: Bool = false
    private(set) var operationErrorMessage: String? = nil
    private(set) var isPerformingAction: Bool = false
    
    private(set) var isLikeActionPending: [Int: Bool] = [:]
    
    private let postId: Int
    private let createCommentUseCase: CreateCommentUseCase
    private let getPostCommentsUseCase: GetPostCommentsUseCase
    private let likeCommentUseCase: LikeCommentUseCase
    private let unlikeCommentUseCase: UnlikeCommentUseCase
    private let getCommentRepliesUseCase: GetCommentRepliesUseCase
    
    private var page = 1
    private let limit = 20
    private var totalCount = 0
    
    private(set) var commentReplies: [Int: [Comment]] = [:]
    private(set) var repliesPage: [Int: Int] = [:]
    private(set) var repliesTotalCount: [Int: Int] = [:]
    private(set) var isRepliesLoading: [Int: Bool] = [:]
    
    private let repliesLimit = 10
    
    var replyingToUsername: String? = nil
        
    var inputPlaceholder: String {
        if let username = replyingToUsername {
            return "Răspunde-i lui @\(username)..."
        }
        return "Adaugă un comentariu..."
    }
    
    var hasMore: Bool {
        guard let currentCount = viewState.comments?.count else { return false }
        return currentCount < totalCount
    }
    
    var isLoading: Bool {
        get { if case .loading = viewState { return true }; return isPerformingAction }
        set { isPerformingAction = newValue }
    }
    
    var errorMessage: String? {
        get {
            if case .error(let msg) = viewState { return msg }
            return operationErrorMessage
        }
        set { operationErrorMessage = newValue }
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
        guard viewState.comments == nil else { return }
        guard viewState != .loading else { return }
        
        page = 1
        await fetch(isFirstPage: true)
    }
    
    func loadMoreIfNeeded(currentComment: Comment?) async {
        guard let comments = viewState.comments, !comments.isEmpty else { return }
        guard hasMore, !isPaging, !isLoading else { return }
        
        guard let current = currentComment,
              current.id == comments.last?.id
        else { return }
        
        isPaging = true
        await fetch(isFirstPage: false)
        isPaging = false
    }
    
    private func fetch(isFirstPage: Bool) async {
        if isFirstPage && viewState.comments != nil {
            return
        }
        
        if isFirstPage {
            viewState = .loading
            operationErrorMessage = nil
        }
        
        do {
            let response: PaginatedResponse<Comment>
            if isFirstPage {
                response = try await withVisibleLoading {
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
            
            if isFirstPage {
                if response.results.isEmpty {
                    viewState = .success([])
                } else {
                    viewState = .success(response.results)
                }
            } else {
                let currentComments = viewState.comments ?? []
                let existingIds = Set(currentComments.map(\.id))
                
                let uniqueNewComments = response.results.filter { !existingIds.contains($0.id) }
                
                viewState = .success(currentComments + uniqueNewComments)
            }
            
            totalCount = response.count
            page += 1
            
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            
            if isFirstPage {
                viewState = .error(message)
            } else {
                operationErrorMessage = message
                print("Eroare la încărcarea paginii următoare de comentarii: \(message)")
            }
        }
    }
    
    func sendComment(text: String, parentId: Int?, replyToCommentId: Int?) async {
        let cleanedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanedText.isEmpty else { return }
        
        operationErrorMessage = nil
        isPerformingAction = true
        
        do {
            let realComment = try await createCommentUseCase(
                postId: postId,
                text: cleanedText,
                parentId: parentId,
                replyToCommentId: replyToCommentId
            )
            
            if let rootId = parentId {
                let currentReplies = commentReplies[rootId] ?? []
                commentReplies[rootId] = currentReplies + [realComment]
                repliesTotalCount[rootId] = (repliesTotalCount[rootId] ?? 0) + 1
            } else {
                let currentComments = viewState.comments ?? []
                viewState = .success([realComment] + currentComments)
                totalCount += 1
            }

            replyingToUsername = nil
            isPerformingAction = false
        } catch {
            operationErrorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            isPerformingAction = false
        }
    }
    
    private func insertNewCommentIntoState(_ newComment: Comment) {
        let currentComments = viewState.comments ?? []
        let updatedComments = [newComment] + currentComments
        
        viewState = .success(updatedComments)
        totalCount += 1
    }
    
    func toggleLikeComment(for commentId: Int) async {
        guard isLikeActionPending[commentId] != true else { return }
        guard let currentComments = viewState.comments else { return }
        
        guard let index = currentComments.firstIndex(where: { $0.id == commentId }) else { return }
        let targetComment = currentComments[index]
        
        let originalComment = targetComment
        let isCurrentlyLiked = targetComment.isLiked
        
        let nextIsLiked = !isCurrentlyLiked
        let nextLikeCount = nextIsLiked ? targetComment.likeCount + 1 : max(0, targetComment.likeCount - 1)
        
        let updatedComment = targetComment.copy(
            likeCount: nextLikeCount,
            isLiked: nextIsLiked,
        )
        
        var updatedList = currentComments
        updatedList[index] = updatedComment
        viewState = .success(updatedList)
        
        isLikeActionPending[commentId] = true
        
        do {
            if isCurrentlyLiked {
                _ = try await unlikeCommentUseCase(commentId: commentId)
            } else {
                _ = try await likeCommentUseCase(commentId: commentId)
            }
            
            isLikeActionPending[commentId] = false
            
        } catch {
            if let currentListNow = viewState.comments,
               let indexNow = currentListNow.firstIndex(where: { $0.id == commentId }) {
                var rollbackList = currentListNow
                rollbackList[indexNow] = originalComment
                viewState = .success(rollbackList)
            }
            
            isLikeActionPending[commentId] = false
            operationErrorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            print("Eroare la toggle like pentru comentariul \(commentId): \(error.localizedDescription)")
        }
    }
    
    func remainingRepliesCount(for parentComment: Comment) -> Int {
        guard let loadedReplies = commentReplies[parentComment.id] else {
            return parentComment.repliesCount
        }
        
        let serverTotal = repliesTotalCount[parentComment.id] ?? parentComment.repliesCount
        return max(0, serverTotal - loadedReplies.count)
    }
    
    func loadReplies(for parentId: Int) async {
        guard isRepliesLoading[parentId] != true else { return }
        
        let currentPage = repliesPage[parentId] ?? 1
        let isFirstPage = currentPage == 1
        
        isRepliesLoading[parentId] = true
        
        do {
            let response = try await getCommentRepliesUseCase(
                postId: postId,
                parentId: parentId,
                page: currentPage,
                limit: repliesLimit
            )
            
            let fetchedReplies = response.results
            let currentLoaded = commentReplies[parentId] ?? []
            
            if isFirstPage {
                commentReplies[parentId] = fetchedReplies
            } else {
                let existingIds = Set(currentLoaded.map(\.id))
                let uniqueReplies = fetchedReplies.filter { !existingIds.contains($0.id) }
                commentReplies[parentId] = currentLoaded + uniqueReplies
            }
            
            repliesTotalCount[parentId] = response.count
            repliesPage[parentId] = currentPage + 1
            isRepliesLoading[parentId] = false
            
        } catch {
            isRepliesLoading[parentId] = false
            print("Eroare la încărcarea răspunsurilor pentru \(parentId): \(error.localizedDescription)")
        }
    }
}
