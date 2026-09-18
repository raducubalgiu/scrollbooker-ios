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
    var activeCameraViewModel: CameraViewModel?
    var activeProfilePostDetailViewModel: ProfilePostDetailViewModel?
    var myProductsViewModel: MyProductsViewModel?

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
    
    func clearCameraSession() {
        activeCameraViewModel = nil
    }

    func clearProfilePostDetailSession() {
        activeProfilePostDetailViewModel = nil
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
        activeCameraViewModel = nil
        activeProfilePostDetailViewModel = nil
        myProfileViewModel = nil
        myProductsViewModel = nil
    }
}

enum MainTab: Int { case feed, inbox, search, appointments, profile }
