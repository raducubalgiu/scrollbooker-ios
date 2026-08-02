//
//  CloudflareRequest.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 01.08.2026.
//

struct CloudflareDirectUploadRequest: Encodable {
    let maxDurationSeconds: Int = 60
    let expirySeconds: Int = 600
    let requireSignedUrls: Bool = true

    enum CodingKeys: String, CodingKey {
        case maxDurationSeconds = "max_duration_seconds"
        case expirySeconds = "expiry_seconds"
        case requireSignedUrls = "require_signed_urls"
    }
}
