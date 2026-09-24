//
//  Router.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI
import Observation

@Observable
@MainActor
final class Router {
    var feedPath = NavigationPath()
    var inboxPath = NavigationPath()
    var searchPath = NavigationPath()
    var appointmentsPath = NavigationPath()
    var profilePath = NavigationPath()
    
    var selectedTab: MainTab = .feed
    var activeBookingViewModel: BookingViewModel?
    var activeProfilePostDetailViewModel: ProfilePostDetailViewModel?
    var myProductsViewModel: MyProductsViewModel?

    // `ReviewVideoDetailScreen` can recurse into itself (its own reviews sheet can push another
    // instance) — tried keeping the sheet mounted via a NavigationStack nested inside the sheet
    // instead of this slot, but that pins the pushed screen inside the sheet's own (non-full-
    // screen) presentation bounds and broke video playback, so back to dismiss-then-push here. A
    // stack (not a single slot like activeProfilePostDetailViewModel) keeps each level of that
    // recursion its own state. Popped via `.onDisappear` on the screen (fires on true nav pop
    // only, not sheet coverage — see `popReviewVideoDetail`).
    private(set) var reviewVideoDetailStack: [ReviewVideoDetailViewModel] = []

    var activeReviewVideoDetailViewModel: ReviewVideoDetailViewModel? {
        reviewVideoDetailStack.last
    }

    // Session-wide singleton (no clearXSession()), unlike the flow slots above — resolved
    // lazily by whichever router needs it first.
    var myProfileViewModel: MyProfileViewModel?

    // Numărul din badge-urile bottom bar-ului (Appointments/Inbox). Încărcate o singură
    // dată la pornirea sesiunii (vezi MainRouter) — nu sunt polled. Actualizarea optimistă
    // locală (increment la crearea unei programări, decrement la marcarea ca citit) e
    // TODO, documentat în CLAUDE.md.
    var appointmentsCount: Int = 0
    var notificationsCount: Int = 0
    
    func push(_ route: Route) {
        switch selectedTab {
        case .feed: feedPath.append(route)
        case .inbox: inboxPath.append(route)
        case .search: searchPath.append(route)
        case .appointments: appointmentsPath.append(route)
        case .profile: profilePath.append(route)
        }
    }
    
    func pop() {
        switch selectedTab {
        case .feed: if !feedPath.isEmpty { feedPath.removeLast() }
        case .inbox: if !inboxPath.isEmpty { inboxPath.removeLast() }
        case .search: if !searchPath.isEmpty { searchPath.removeLast() }
        case .appointments: if !appointmentsPath.isEmpty { appointmentsPath.removeLast() }
        case .profile: if !profilePath.isEmpty { profilePath.removeLast() }
        }
    }
    
    /// Same as `push(_:)`, but without the NavigationStack's implicit slide-in transition —
    /// for destinations meant to feel like an instant cut rather than another step deeper in
    /// the stack (e.g. ProfilePostDetailScreen, opened from a grid tap).
    func pushWithoutAnimation(_ route: Route) {
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            push(route)
        }
    }

    /// Same as `pop()`, without the slide-out transition — pairs with `pushWithoutAnimation(_:)`
    /// so entering and leaving that same destination are both instant.
    func popWithoutAnimation() {
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            pop()
        }
    }

    func popToRoot() {
        switch selectedTab {
        case .feed: feedPath = .init()
        case .inbox: inboxPath = .init()
        case .search: searchPath = .init()
        case .appointments: appointmentsPath = .init()
        case .profile: profilePath = .init()
        }
    }
    
    func clearBookingSession() {
        activeBookingViewModel = nil
    }
    
    func clearProfilePostDetailSession() {
        activeProfilePostDetailViewModel = nil
    }

    func pushReviewVideoDetail(_ viewModel: ReviewVideoDetailViewModel) {
        reviewVideoDetailStack.append(viewModel)
        push(.reviewVideoDetail)
    }

    /// Pops exactly one stack entry, only if `viewModel` is still the top — called from the
    /// screen's `.onDisappear`, which fires once per true pop regardless of whether it happened
    /// via the close button or the system swipe-back gesture.
    func popReviewVideoDetail(_ viewModel: ReviewVideoDetailViewModel) {
        if reviewVideoDetailStack.last === viewModel {
            reviewVideoDetailStack.removeLast()
        }
    }

    func clearReviewVideoDetailSession() {
        reviewVideoDetailStack.removeAll()
    }

    func clearMyProductsSession() {
        myProductsViewModel = nil
    }

    func resetAll() {
        feedPath = .init()
        inboxPath = .init()
        searchPath = .init()
        appointmentsPath = .init()
        profilePath = .init()
        activeBookingViewModel = nil
        activeProfilePostDetailViewModel = nil
        reviewVideoDetailStack.removeAll()
        myProfileViewModel = nil
        myProductsViewModel = nil
    }
}

enum MainTab: Int { case feed, inbox, search, appointments, profile }
