//
//  Router.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

@MainActor
final class Router: ObservableObject {
    @Published var feedPath = NavigationPath()
    @Published var inboxPath = NavigationPath()
    @Published var searchPath  = NavigationPath()
    @Published var appointmentsPath = NavigationPath()
    @Published var profilePath = NavigationPath()
    
    @Published var selectedTab: MainTab = .feed
    
    /// Adaugă un ecran nou pe stiva tab-ului curent (Push)
    func push(_ route: Route) {
        switch selectedTab {
        case .feed: feedPath.append(route)
        case .inbox: inboxPath.append(route)
        case .search: searchPath.append(route)
        case .appointments: appointmentsPath.append(route)
        case .profile: profilePath.append(route)
        }
    }
    
    /// Șterge ultimul ecran de pe stiva tab-ului curent (Back / Pop)
    /// Util pentru butoane custom de „Înapoi” din interfață
    func pop() {
        switch selectedTab {
        case .feed: if !feedPath.isEmpty { feedPath.removeLast() }
        case .inbox: if !inboxPath.isEmpty { inboxPath.removeLast() }
        case .search: if !searchPath.isEmpty { searchPath.removeLast() }
        case .appointments: if !appointmentsPath.isEmpty { appointmentsPath.removeLast() }
        case .profile: if !profilePath.isEmpty { profilePath.removeLast() }
        }
    }
    
    /// Resetează IMEDIAT doar tab-ul curent înapoi la ecranul principal (Pop to Root)
    /// Folosit când utilizatorul apasă din nou pe iconița tab-ului activ din tab bar
    func popToRoot() {
        switch selectedTab {
        case .feed: feedPath = .init()
        case .inbox: inboxPath = .init()
        case .search: searchPath = .init()
        case .appointments: appointmentsPath = .init()
        case .profile: profilePath = .init()
        }
    }
    
    /// Resetează absolut toate stivele din aplicație (ex: la Logout)
    func resetAll() {
        feedPath = .init()
        inboxPath = .init()
        searchPath = .init()
        appointmentsPath = .init()
        profilePath = .init()
    }
 }

enum MainTab: Int { case feed, inbox, search, appointments, profile }
