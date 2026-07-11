//
//  Consent.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct Consent: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let name: String
    let title: String
    let text: String
    let version: String
    let createdAt: String
}
