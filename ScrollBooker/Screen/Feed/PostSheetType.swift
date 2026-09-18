//
//  PostSheetType.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.07.2026.
//

import Foundation

enum FeedSheetType: Identifiable {
    case comments(postId: Int)
    case reviews(post: Post)
    case linkedProducts(post: Post)
    case moreOptions(postId: Int)

    var id: String {
        switch self {
        case .comments(let postId):
            return "comments-\(postId)"
        case .reviews(let post):
            return "reviews-\(post.id)"
        case .linkedProducts(let post):
            return "products-\(post.id)"
        case .moreOptions(let postId):
            return "more-\(postId)"
        }
    }
}
