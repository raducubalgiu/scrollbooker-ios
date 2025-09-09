//
//  SearchUsername.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.09.2025.
//

import Foundation

struct SearchUsername: Equatable, Hashable {
    let available: Bool
    let suggestions: [String]
    let username: String?
}
