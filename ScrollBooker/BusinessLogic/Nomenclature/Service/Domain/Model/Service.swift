//
//  Service.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct Service: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let name: String
    let shortName: String
    let description: String?
    let businessDomainId: Int
}
