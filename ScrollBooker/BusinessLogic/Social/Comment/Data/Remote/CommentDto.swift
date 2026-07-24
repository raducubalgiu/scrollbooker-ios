//
//  CommentDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct CommentDto: Decodable {
    let id: Int
    let text: String
    let user: CommentUserDto
    let postId: Int
    let likeCount: Int
    let isLiked: Bool
    let likedbyPostAuthor: Bool
    let repliesCount: Int
    let parentId: Int?
    let replyToCommentId: Int?
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case user
        case postId = "post_id"
        case likeCount = "like_count"
        case isLiked = "is_liked"
        case likedbyPostAuthor = "liked_by_post_author"
        case repliesCount = "replies_count"
        case parentId = "parent_id"
        case replyToCommentId = "reply_to_comment_id"
        case createdAt = "created_at"
    }
}

struct CommentUserDto: Decodable {
    let id: Int
    let fullName: String
    let username: String
    let avatar: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "fullname"
        case username
        case avatar
    }
}
