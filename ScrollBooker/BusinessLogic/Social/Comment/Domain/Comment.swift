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
    let repliesCount: Int
    let likeCount: Int
    let isLiked: Bool
    let likedByPostAuthor: Bool
    let parentId: Int?
    let createdAt: Date
}

struct CommentUser: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let username: String
    let fullname: String
    let avatar: String?
    
    var avatarURL: URL? { avatar.flatMap(URL.init(string:)) }
}
