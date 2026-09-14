//
//  LinkedProductsViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.07.2026.
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class LinkedProductsViewModel {
    private(set) var viewState: FeatureState<[Product]> = .idle
    
    var isSaving: Bool = false
    var isRefreshing: Bool = false
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "LinkedProducts")
    
    private let postId: Int
    private let getPostLinkedProductsUseCase: GetPostLinkedProductsUseCase
    
    init(postId: Int, getPostLinkedProductsUseCase: GetPostLinkedProductsUseCase) {
        self.postId = postId
        self.getPostLinkedProductsUseCase = getPostLinkedProductsUseCase
    }
    
    func loadLinkedProducts() async {
        guard viewState.data == nil else { return }
        guard viewState != .loading else { return }
        
        viewState = .loading
        
        do {
            let result = try await withLoading {
                try await getPostLinkedProductsUseCase(postId: postId)
            }
            viewState = .success(result)
        } catch {
            viewState = .error(logger.userMessage(for: error, context: "Fetching Linked Products for Post (\(self.postId))"))
        }
    }
    
    func refresh() async {
        guard !isRefreshing else { return }
        isRefreshing = true
        
        do {
            let result = try await getPostLinkedProductsUseCase(postId: postId)
            viewState = .success(result)
        } catch {
            let message = logger.userMessage(for: error, context: "Refreshing Linked Products")
            if viewState.data == nil {
                viewState = .error(message)
            }
        }
        isRefreshing = false
    }
}

