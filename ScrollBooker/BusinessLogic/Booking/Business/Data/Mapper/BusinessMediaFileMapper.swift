//
//  BusinessMediaFile.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.07.2026.
//

extension BusinessMediaFile {
    init(dto: BusinessMediaFileDto) {
        self.url = dto.url
        self.urlKey = dto.urlKey
        self.thumbnailUrl = dto.thumbnailUrl
        self.thumbnailKey = dto.thumbnailKey
        self.type = dto.type
        self.orderIndex = dto.orderIndex
    }
}
