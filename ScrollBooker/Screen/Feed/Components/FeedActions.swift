//
//  FeedActions.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.07.2026.
//

import SwiftUI

struct FeedActions {
    var onNavigateToUserProfile: (ProfileNavigationParams) -> Void = { _ in }
    var onNavigateToBooking: (BookingNavigationParams) -> Void = { _ in }
    var onOpenReviewsSheet: (Int) -> Void = { _ in }
    var onOpenLinkedProductsSheet: (Int) -> Void = { _ in }
    var onOpenCommentsSheet: (Int) -> Void = { _ in }
    var onLike: (Int) -> Void = { _ in }
    var onBookmark: (Int) -> Void = { _ in }
}

struct FeedActionsKey: EnvironmentKey {
    static let defaultValue = FeedActions()
}

extension EnvironmentValues {
    var feedActions: FeedActions {
        get { self[FeedActionsKey.self] }
        set { self[FeedActionsKey.self] = newValue }
    }
}
