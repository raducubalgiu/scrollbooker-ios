//
//  BusinessDetails.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import Foundation

struct BusinessDetails: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let owner: BusinessOwner
    let location: BusinessLocation
    let hasEmployees: Bool
    let mediaFiles: [BusinessMediaFile]
    let schedules: [Schedule]
}
