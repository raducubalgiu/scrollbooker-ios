//
//  Router.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

@MainActor
final class Router: ObservableObject {
    // Un Stack per tab
    @Published var feedPath = NavigationPath()
    @Published var inboxPath = NavigationPath()
    @Published var searchPath  = NavigationPath()
    @Published var appointmentsPath = NavigationPath()
    @Published var profilePath = NavigationPath()
    
    // Tab Curent
    @Published var selectedTab: MainTab = .feed
    
    func resetAll() {
        feedPath = .init()
        inboxPath = .init()
        searchPath = .init()
        appointmentsPath = .init()
        profilePath = .init()
    }
    
    // generic
    func push(_ route: Route) {
        switch(selectedTab) {
            case .feed: feedPath.append(route)
            case .inbox: inboxPath.append(route)
            case .search: searchPath.append(route)
            case .appointments: appointmentsPath.append(route)
            case .profile: profilePath.append(route)
        }
    }
 }

enum MainTab: Int { case feed, inbox, search, appointments, profile }
