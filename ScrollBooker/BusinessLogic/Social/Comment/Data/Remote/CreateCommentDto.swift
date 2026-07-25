//
//  CreateCommentDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.07.2026.
//

struct CreateCommentRequest: Encodable {
    let text: String
    let parentId: Int?
    let replyToCommentId: Int?
    
    enum CodingKeys: String, CodingKey {
        case text
        case parentId = "parent_id"
        case replyToCommentId = "reply_to_comment_id"
    }
}

