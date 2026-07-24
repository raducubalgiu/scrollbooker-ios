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
    case linkedProducts(postId: Int)
    case moreOptions(postId: Int)
    
    var id: String {
        switch self {
        case .comments(let postId):
            return "comments-\(postId)"
        case .reviews(let userId):
            return "reviews-\(userId)"
        case .linkedProducts(let postId):
            return "products-\(postId)"
        case .moreOptions(let postId):
            return "more-\(postId)"
        }
    }
}
