//
//  RegisterRequestMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.09.2025.
//

import Foundation

extension RegisterRequest {
    init(dto: RegisterRequestDTO) {
        self.email = dto.email
        self.password = dto.password
        self.roleName = dto.role_name
    }
}
