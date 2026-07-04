//
//  CommentMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

extension Comment {
    init(dto: CommentDto) throws {
        guard let parsedDate = DateParser.parseISO8601UTC(dto.created_at) else {
            throw MappingError.invalidDate(dto.created_at)
        }
        
        self.id = dto.id
        self.text = dto.text
        self.user = CommentUser(dto: dto.user)
        self.postId = dto.post_id
        self.repliesCount = dto.replies_count
        self.likeCount = dto.like_count
        self.isLiked = dto.is_liked
        self.likedByPostAuthor = dto.liked_by_post_author
        self.parentId = dto.parent_id
        self.createdAt = parsedDate
    }
}

extension CommentUser {
    init(dto: CommentUserDto) {
        self.id = dto.id
        self.username = dto.username
        self.fullname = dto.fullname
        self.avatar = dto.avatar
    }
}
