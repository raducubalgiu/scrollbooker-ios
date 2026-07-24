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
final class CommentsViewModel {
    private(set) var viewState: CommentsState = .idle
    private(set) var isPaging: Bool = false
    private(set) var operationErrorMessage: String? = nil
    private(set) var isPerformingAction: Bool = false
    
    private let postId: Int
    private let getPostCommentsUseCase: GetPostCommentsUseCase
    
    private var page = 1
    private let limit = 20
    private var totalCount = 0
    
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
    
    init(postId: Int, getPostCommentsUseCase: GetPostCommentsUseCase) {
        self.postId = postId
        self.getPostCommentsUseCase = getPostCommentsUseCase
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
        if isFirstPage {
            viewState = .loading
            operationErrorMessage = nil
        }
        
        do {
            let response = try await getPostCommentsUseCase(
                postId: postId,
                page: page,
                limit: limit
            )
            
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
}
