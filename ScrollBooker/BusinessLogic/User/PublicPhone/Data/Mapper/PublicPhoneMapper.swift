//
//  PublicPhoneMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.10.2026.
//

import Foundation

extension PublicPhoneInfo {
    init(dto: PublicPhoneInfoDTO) {
        self.publicPhone = dto.publicPhone
        self.publicPhoneVerified = dto.publicPhoneVerified
        self.businessPublicPhone = dto.businessPublicPhone
        self.businessPublicPhoneVerified = dto.businessPublicPhoneVerified
    }
}

extension PublicPhoneUpdateResult {
    init(dto: PublicPhoneUpdateResultDTO) {
        self.publicPhone = dto.publicPhone
        self.publicPhoneVerified = dto.publicPhoneVerified
    }
}
