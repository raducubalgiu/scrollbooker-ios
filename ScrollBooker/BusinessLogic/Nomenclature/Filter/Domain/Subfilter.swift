//
//  Subfilter.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct SubFilter: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let name: String
    let description: String?
}
