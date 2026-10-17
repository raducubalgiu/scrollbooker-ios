//
//  AccountInfoMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.10.2026.
//

import Foundation

extension AccountInfo {
    init(dto: AccountInfoDTO) {
        self.privatePhone = dto.privatePhone
        self.privatePhoneVerified = dto.privatePhoneVerified
        self.email = dto.email
        self.emailVerified = dto.emailVerified
    }
}

extension PrivatePhoneVerificationResult {
    init(dto: PrivatePhoneVerificationResultDTO) {
        self.privatePhone = dto.privatePhone
        self.privatePhoneVerified = dto.privatePhoneVerified
    }
}
