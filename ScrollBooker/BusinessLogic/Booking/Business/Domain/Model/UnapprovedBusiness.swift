//
//  UnapprovedBusiness.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import Foundation

struct UnapprovedBusiness: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let fullName: String
    let username: String
    let avatar: String?
    let business: UnapprovedBusinessData

    var avatarURL: URL? { avatar.flatMap(URL.init(string:)) }
}

struct UnapprovedBusinessData: Equatable, Hashable, Sendable {
    let id: Int
    let hasEmployees: Bool
    let location: UnapprovedLocation
    let businessType: UnapprovedBusinessType
}

struct UnapprovedLocation: Equatable, Hashable, Sendable {
    let coordinates: BusinessCoordinates
    let address: String
}

struct UnapprovedBusinessType: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let name: String
}
