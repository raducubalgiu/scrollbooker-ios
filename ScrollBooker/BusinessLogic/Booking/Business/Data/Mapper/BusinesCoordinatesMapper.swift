//
//  BusinesCoordinatesMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

extension BusinessCoordinates {
    init(dto: BusinessCoordinatesDto) {
        self.lat = Double(dto.lat)
        self.lng = Double(dto.lng)
    }
}
