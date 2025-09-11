//
//  AuthResponseMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.09.2025.
//

import Foundation

extension AuthResponse {
    init(dto: AuthResponseDTO) {
        self.accessToken = dto.access_token
        self.refreshToken = dto.refresh_token
        self.tokenType = dto.token_type
    }
}
