//
//  UiState.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct UiState<T> {

    var data: T

    var isLoading = false

    var isRefreshing = false

    var errorMessage: String?

}
