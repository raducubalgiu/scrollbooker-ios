//
//  PostViewEventsBulkRequest.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.10.2026.
//

struct PostViewEventBulkItem: Encodable, Sendable {
    let eventId: String
    let postId: Int
    let sessionId: String
    let source: PostViewSourceEnum
    let platform: PostViewPlatformEnum
    let watchedMsDelta: Int
    let positionMs: Int
    let mediaDurationMs: Int?
    let capturedAt: Int
    let viewerFingerprintHash: String?

    enum CodingKeys: String, CodingKey {
        case eventId = "event_id"
        case postId = "post_id"
        case sessionId = "session_id"
        case source
        case platform
        case watchedMsDelta = "watched_ms_delta"
        case positionMs = "position_ms"
        case mediaDurationMs = "media_duration_ms"
        case capturedAt = "captured_at"
        case viewerFingerprintHash = "viewer_fingerprint_hash"
    }
}

struct PostViewEventsBulkRequest: Encodable, Sendable {
    let events: [PostViewEventBulkItem]
    let clientBatchId: String

    enum CodingKeys: String, CodingKey {
        case events
        case clientBatchId = "client_batch_id"
    }
}

struct PostViewEventsBulkResponse: Decodable, Sendable {
    let accepted: Int
    let rejected: [String]
}
