//
//  PostSheetType.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.07.2026.
//

import Foundation

enum FeedSheetType: Identifiable {
    case comments(postId: Int)
    // Carries the whole Post (not just a userId) — the sheet needs post.businessId and
    // must derive employeeId from post.user vs. post.businessOwner (see makeReviewsVM call sites).
    case reviews(post: Post)
    // Carries the whole Post (not just its id) — the sheet needs post.user.id and
    // post.isVideoReview to decide between the regular products list and the video-review layout.
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
