//
//  UserInfo.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.09.2025.
//

import Foundation

struct UserInfo: Codable, Hashable, Identifiable {
    let id: Int
    let username: String
    let fullName: String
    let profession: String
    let avatar: String?
    let businessId: Int?
    let businessOwnerId: Int?
    let businessTypeId: Int?
    let hasEmployees: Bool
    let isValidated: Bool
    let registrationStep: RegistrationStepEnum?
}
