//
//  PostSheetType.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.07.2026.
//

import Foundation

enum FeedSheetType: Identifiable {
    case comments(postId: Int)
    case reviews(userId: Int)
    // Carries the whole Post (not just its id) — the sheet needs post.user.id and
    // post.isVideoReview to decide between the regular products list and the video-review layout.
    case linkedProducts(post: Post)
    case moreOptions(postId: Int)

    var id: String {
        switch self {
        case .comments(let postId):
            return "comments-\(postId)"
        case .reviews(let userId):
            return "reviews-\(userId)"
        case .linkedProducts(let post):
            return "products-\(post.id)"
        case .moreOptions(let postId):
            return "more-\(postId)"
        }
    }
}
