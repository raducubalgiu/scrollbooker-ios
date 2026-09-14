//
//  AuthState.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 03.09.2025.
//

import Foundation

struct AuthState: Codable, Hashable {
    let isValidated: Bool
    let registrationStep: RegistrationStepEnum?
}
