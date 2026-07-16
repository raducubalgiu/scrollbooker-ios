//
//  BusinessSheetMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.07.2026.
//

extension BusinessSheet {
    init(dto: BusinessSheetDto) {
        self.id = dto.id
        self.owner = BusinessOwner(dto: dto.owner)
        self.businessShortDomain = dto.businessShortDomain
        self.address = dto.address
        self.coordinates = dto.coordinates
        self.hasVideo = dto.hasVideo
        self.mediaFiles = dto.mediaFiles.map { BusinessMediaFile(dto: $0) }
        self.products = dto.products.map { Product(dto: $0) }
        self.distance = dto.distance
    }
}
