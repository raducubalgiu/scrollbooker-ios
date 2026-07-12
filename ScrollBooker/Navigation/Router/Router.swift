//
//  Router.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

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
    
    func popToRoot() {
        switch selectedTab {
        case .feed: feedPath = .init()
        case .inbox: inboxPath = .init()
        case .search: searchPath = .init()
        case .appointments: appointmentsPath = .init()
        case .profile: profilePath = .init()
        }
    }
    
    func resetAll() {
        feedPath = .init()
        inboxPath = .init()
        searchPath = .init()
        appointmentsPath = .init()
        profilePath = .init()
    }
}

enum MainTab: Int { case feed, inbox, search, appointments, profile }
