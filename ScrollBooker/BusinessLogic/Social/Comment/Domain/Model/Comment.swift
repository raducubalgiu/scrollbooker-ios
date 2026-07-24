//
//  Comment.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct Comment: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let text: String
    let user: CommentUser
    let postId: Int
    let likeCount: Int
    let isLiked: Bool
    let likedbyPostAuthor: Bool
    let repliesCount: Int
    let parentId: Int?
    let replyToCommentId: Int?
    let createdAt: Date
}

struct CommentUser: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let fullName: String
    let username: String
    let avatar: String?
    
    var avatarURL: URL? { avatar.flatMap(URL.init(string:)) }
}
