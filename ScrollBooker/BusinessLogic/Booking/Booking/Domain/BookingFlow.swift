//
//  BookingFlow.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation
import SwiftUICore

struct BookingFlow: Equatable, Hashable, Sendable {
    let business: BookingFlowBusiness
    let products: UserProducts
    let employees: [BookingFlowUser]
}

struct BookingFlowBusiness: Equatable, Hashable, Sendable {
    let owner: BookingFlowUser
    let hasEmployees: Bool
    let formattedAddress: String
}

struct BookingFlowUser: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let username: String
    let fullName: String
    let profession: String
    let avatar: String?
    let ratingsCount: Int
    let ratingsAverage: Double
    
    var avatarURL: URL? { avatar.flatMap(URL.init(string:)) }
}
