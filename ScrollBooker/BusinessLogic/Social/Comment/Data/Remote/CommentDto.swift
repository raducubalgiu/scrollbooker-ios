//
//  CommentDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct CommentDto: Codable {
    let id: Int
    let text: String
    let user: CommentUserDto
    let post_id: Int
    let replies_count: Int
    let like_count: Int
    let is_liked: Bool
    let liked_by_post_author: Bool
    let parent_id: Int?
    let created_at: String
}

struct CommentUserDto: Codable {
    let id: Int
    let username: String
    let fullname: String
    let avatar: String?
}
