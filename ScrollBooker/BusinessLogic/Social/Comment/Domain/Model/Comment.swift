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

extension Comment {
    func copy(
        id: Int? = nil,
        text: String? = nil,
        user: CommentUser? = nil,
        postId: Int? = nil,
        likeCount: Int? = nil,
        isLiked: Bool? = nil,
        likedbyPostAuthor: Bool? = nil,
        repliesCount: Int? = nil,
        parentId: Int?? = nil,
        replyToCommentId: Int?? = nil,    
        createdAt: Date? = nil
    ) -> Comment {
        Comment(
            id: id ?? self.id,
            text: text ?? self.text,
            user: user ?? self.user,
            postId: postId ?? self.postId,
            likeCount: likeCount ?? self.likeCount,
            isLiked: isLiked ?? self.isLiked,
            likedbyPostAuthor: likedbyPostAuthor ?? self.likedbyPostAuthor,
            repliesCount: repliesCount ?? self.repliesCount,
            parentId: parentId ?? self.parentId,
            replyToCommentId: replyToCommentId ?? self.replyToCommentId,
            createdAt: createdAt ?? self.createdAt
        )
    }
}
