//
//  BusinessDomain.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct BusinessDomain: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let name: String
    let shortName: String
    let serviceDomains: [ServiceDomain]
    let businessTypes: [BusinessType]
}
