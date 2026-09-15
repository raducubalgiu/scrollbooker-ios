//
//  BusinessCreateResponse.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import Foundation

struct BusinessCreateResponse: Identifiable, Equatable, Hashable, Sendable {
    let businessId: Int
    let businessTypeId: Int
    let onboardingState: AuthState

    var id: Int { businessId }
}
