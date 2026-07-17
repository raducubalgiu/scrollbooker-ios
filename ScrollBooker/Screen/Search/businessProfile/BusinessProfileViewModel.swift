//
//  BusinessProfileViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.07.2026.
//

import Foundation
import Observation

enum BusinessProfileState {
    case idle
    case loading
    case empty
    case success([BusinessProfile])
    case error(String)
}

@Observable
@MainActor
final class BusinessProfileViewModel: HasLoadingState {
    var uiState = UiState(data: [BusinessProfile]())
    
    let username: String
    
    private(set) var viewState: BusinessProfileState = .idle
    
    var isLoading: Bool {
        get { if case .loading = viewState { return true }; return uiState.isLoading }
        set { uiState.isLoading = newValue }
    }
    
    var errorMessage: String? {
        get { if case .error(let msg) = viewState { return msg }; return uiState.errorMessage }
        set { uiState.errorMessage = newValue }
    }
    
    init(username: String) {
        self.username = username
    }
}
