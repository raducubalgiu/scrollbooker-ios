//
//  BusinessProfileViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.07.2026.
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class BusinessProfileViewModel {
    private(set) var viewState: FeatureState<BusinessProfile> = .idle
    
    var isSaving: Bool = false
    var isRefreshing: Bool = false
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "BusinessProfile")
    
    private let username: String
    private let getBusinessProfileUseCase: GetBusinessProfileUseCase
    
    init(
        username: String,
        getBusinessProfileUseCase: GetBusinessProfileUseCase
    ) {
        self.username = username
        self.getBusinessProfileUseCase = getBusinessProfileUseCase
    }
    
    func loadBusinessProfile() async {
        guard viewState.data == nil else { return }
        guard viewState != .loading else { return }
        
        viewState = .loading
        
        do {
            let result = try await withLoading {
                try await getBusinessProfileUseCase(username: username)
            }
            viewState = .success(result)
        } catch {
            viewState = .error(logger.userMessage(for: error, context: "Fetching Business Profile (\(self.username))"))
        }
    }
    
    func refresh() async {
        guard !isRefreshing else { return }
        isRefreshing = true
        
        do {
            let result = try await getBusinessProfileUseCase(username: username)
            viewState = .success(result)
        } catch {
            let message = logger.userMessage(for: error, context: "Refreshing Business Profile")

            if viewState.data == nil {
                viewState = .error(message)
            }
        }
        isRefreshing = false
    }
}

