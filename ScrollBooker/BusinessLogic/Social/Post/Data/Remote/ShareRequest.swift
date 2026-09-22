//
//  ShareRequest.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.09.2026.
//

struct ShareRequest: Encodable, Sendable {
    let channel: ShareChannelEnum
    
    enum CodingKeys: String, CodingKey {
        case channel = "channel"
    }
}
