//
//  BusinessMarkerMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.07.2026.
//

import Foundation

extension BusinessMarker {
    init(dto: BusinessMarkerDto) {
        self.id = dto.id
        self.owner = BusinessOwner(dto: dto.owner)
        self.businessShortDomain = BusinessShortDomainEnum(fromKeyOrUnknown: dto.businessShortDomain)
        self.address = dto.address
        self.coordinates = BusinessCoordinates(dto: dto.coordinates)
        self.isPrimary = dto.isPrimary
        self.mediaFiles = dto.mediaFiles.map { dtoFile in
            if let dtoFile = dtoFile {
                return BusinessMediaFile(dto: dtoFile)
            } else {
                return nil
            }
        }
    }
}
