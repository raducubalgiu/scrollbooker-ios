//
//  FilterMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

extension Filter {
    init(dto: FilterDto) {
        self.id = dto.id
        self.name = dto.name
        self.singleSelect = dto.single_select
        
        self.type = FilterTypeEnum.fromKey(dto.type)

        self.subFilters = dto.sub_filters.map { SubFilter(dto: $0) }
        
        self.unit = dto.unit
    }
}
