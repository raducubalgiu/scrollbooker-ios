//
//  BusinessClient.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.09.2026.
//

import Foundation

struct BusinessClient: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let businessId: Int
    let userId: Int?
    let fullname: String
    let phone: String?
}
