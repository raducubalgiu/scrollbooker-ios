//
//  LoginResponseMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.09.2025.
//

import Foundation

extension LoginResponse {
    init(dto: LoginResponseDTO) {
        self.accessToken = dto.access_token
        self.refreshToken = dto.refresh_token
        self.tokenType = dto.token_type
    }
}
