//
//  CloudflareDirectUpload.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 01.08.2026.
//

struct CloudflareDirectUpload: Identifiable, Equatable, Hashable, Sendable {
    var id: String { providerUid }
    
    let providerUid: String
    let uploadUrl: String
    let watermark: String?
    let scheduledDeletion: String?
}

