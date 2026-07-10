//
//  SelectedServiceDomainsWithServicesMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

extension SelectedServiceDomainsWithServices {
    init(dto: SelectedServiceDomainsWithServicesDto) {
        self.id = dto.id
        self.name = dto.name
        self.services = dto.services.map { SelectedService(dto: $0) }
    }
}

extension SelectedService {
    init(dto: SelectedServiceDto) {
        self.id = dto.id
        self.name = dto.name
        self.shortName = dto.shortName
        self.isSelected = dto.isSelected
    }
}
