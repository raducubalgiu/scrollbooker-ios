//
//  LoginRequesrMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.09.2025.
//

extension LoginRequest {
    init(dto: LoginRequestDTO) {
        self.username = dto.username
        self.password = dto.password
    }
}
