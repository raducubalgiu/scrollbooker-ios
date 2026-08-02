//
//  CloudflareDirectUploadDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 01.08.2026.
//

struct CloudflareDirectUploadDto: Decodable {
    let providerUid: String
    let uploadUrl: String
    let watermark: String?
    let scheduledDeletion: String?

    enum CodingKeys: String, CodingKey {
        case providerUid = "provider_uid"
        case uploadUrl = "upload_url"
        case watermark
        case scheduledDeletion = "scheduled_deletion"
    }
}
