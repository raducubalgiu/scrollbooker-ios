//
//  AuthStateMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.09.2025.
//

import Foundation

extension AuthState {
    init(dto: AuthStateDTO) {
        self.isValidated = dto.is_validated
        self.registrationStep = RegistrationStepEnum.fromKeyOrNull(dto.registration_step)
    }
}
