//
//  CloudflareMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 01.08.2026.
//

extension CloudflareDirectUpload {
    init(dto: CloudflareDirectUploadDto) throws {
        self.providerUid = dto.providerUid
        self.uploadUrl = dto.uploadUrl
        self.watermark = dto.watermark
        self.scheduledDeletion = dto.scheduledDeletion
    }
}
