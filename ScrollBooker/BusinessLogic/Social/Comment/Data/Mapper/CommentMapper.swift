//
//  CommentMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

extension Comment {
    init(dto: CommentDto) throws {
        guard let parsedDate = DateParser.parseISO8601UTC(dto.createdAt) else {
            throw MappingError.invalidDate(dto.createdAt)
        }
        
        self.id = dto.id
        self.text = dto.text
        self.user = CommentUser(dto: dto.user)
        self.postId = dto.postId
        self.likeCount = dto.likeCount
        self.isLiked = dto.isLiked
        self.likedbyPostAuthor = dto.likedbyPostAuthor
        self.repliesCount = dto.repliesCount
        self.parentId = dto.parentId
        self.replyToCommentId = dto.replyToCommentId
        self.createdAt = parsedDate
    }
}

extension CommentUser {
    init(dto: CommentUserDto) {
        self.id = dto.id
        self.username = dto.username
        self.fullName = dto.fullName
        self.avatar = dto.avatar
    }
}
