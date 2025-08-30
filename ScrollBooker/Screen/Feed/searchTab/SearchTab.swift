//
//  SearchTab.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 30.08.2025.
//

import SwiftUI

enum SearchTab: String, CaseIterable, Identifiable {
    case forYou = "For You"
    case users = "Utilizatori"
    case lastMinute = "Last Minute"

    var id: String { rawValue }
}
