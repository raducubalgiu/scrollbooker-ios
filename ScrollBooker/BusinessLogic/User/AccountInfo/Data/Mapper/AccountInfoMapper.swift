//
//  AccountInfoMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.10.2026.
//

import Foundation

extension AccountInfo {
    init(dto: AccountInfoDTO) {
        self.phone = dto.phone
        self.phoneVerified = dto.phoneVerified
        self.email = dto.email
        self.emailVerified = dto.emailVerified
    }
}

extension PhoneVerificationResult {
    init(dto: PhoneVerificationResultDTO) {
        self.phone = dto.phone
        self.phoneVerified = dto.phoneVerified
    }
}
