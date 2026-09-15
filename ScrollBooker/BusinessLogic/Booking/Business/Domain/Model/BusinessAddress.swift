//
//  BusinessAddress.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import Foundation

struct BusinessAddress: Identifiable, Equatable, Hashable, Sendable {
    let placeId: String
    let description: String

    var id: String { placeId }
}
