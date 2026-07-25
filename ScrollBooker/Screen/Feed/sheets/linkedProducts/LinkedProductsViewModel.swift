//
//  LinkedProductsViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.07.2026.
//

import SwiftUI
import Observation
import Foundation

enum LinkedProductsState: Equatable {
    case idle
    case loading
    case success([Product])
    case error(String)
    
    var products: [Product]? {
        if case .success(let products) = self { return products }
        return nil
    }
}

@Observable
@MainActor
final class LinkedProductsViewModel: HasLoadingState {
    private(set) var viewState: LinkedProductsState = .idle
    
    var isRefreshing: Bool = false
    private(set) var operationErrorMessage: String? = nil
    private(set) var isPerformingAction: Bool = false
    
    private let postId: Int
    private let getPostLinkedProductsUseCase: GetPostLinkedProductsUseCase
    
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
    
    init(postId: Int, getPostLinkedProductsUseCase: GetPostLinkedProductsUseCase) {
        self.postId = postId
        self.getPostLinkedProductsUseCase = getPostLinkedProductsUseCase
    }
    
    func loadLinkedProducts() async {
        guard viewState.products == nil else { return }
        guard viewState != .loading else { return }
        
        viewState = .loading
        operationErrorMessage = nil
        
        do {
            let result = try await withVisibleLoading {
                try await getPostLinkedProductsUseCase(postId: postId)
            }
            
            if result.isEmpty {
                viewState = .success(result)
            } else {
                viewState = .success(result)
            }
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            viewState = .error(message)
        }
    }
    
    func refresh() async {
        guard !isRefreshing else { return }
        isRefreshing = true
        operationErrorMessage = nil
        
        do {
            let result = try await getPostLinkedProductsUseCase(postId: postId)
            viewState = .success(result)
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            if viewState.products == nil {
                viewState = .error(message)
            } else {
                operationErrorMessage = message
            }
        }
        isRefreshing = false
    }
}

