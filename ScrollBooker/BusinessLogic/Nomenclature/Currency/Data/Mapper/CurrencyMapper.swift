//
//  CurrencyMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

extension Currency {
    init(dto: CurrencyDto) {
        self.id = dto.id
        self.name = dto.name
    }
}
