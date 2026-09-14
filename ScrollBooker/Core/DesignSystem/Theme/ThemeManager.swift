//
//  ThemeManager.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 12.08.2025.
//

import SwiftUI
import Observation

@Observable
final class ThemeManager {
    @ObservationIgnored @AppStorage("theme.mode") private var storedMode: String = ThemeMode.system.rawValue

    var mode: ThemeMode {
        didSet { storedMode = mode.rawValue }
    }
    
    init() {
        let raw = UserDefaults.standard.string(forKey: "theme.mode")
        ?? ThemeMode.system.rawValue
        
        self.mode = ThemeMode(rawValue: raw) ?? .system
    }
}
