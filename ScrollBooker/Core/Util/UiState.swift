//
//  UiState.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

enum UIState<T: Sendable>: Sendable {
    case idle
    case loading
    case success(T)
    case error(message: String)
}
