//
//  Post.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 03.09.2025.
//

import Foundation

struct Post: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let description: String?
    let user: PostUser
    let businessOwner: PostBusinessOwner
    let employee: PostEmployee?
    let businessLocation: PostBusinessLocation?
    let counters: PostCounters
    let userActions: UserPostActions
    let mediaFiles: [PostMediaFile]
    let hashtags: [Hashtag]?
    let isVideoReview: Bool
    let isOwnPost: Bool
    let businessId: Int?
    let review: PostReview?
    let serviceDomain: PostServiceDomain?
    let createdAt: String
}

struct PostUser: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let fullName: String
    let username: String
    let avatar: String?
    let isFollow: Bool
    let profession: String
    let ratingsAverage: Float
    let ratingsCount: Int
    
    var avatarURL: URL? { avatar.flatMap(URL.init(string:)) }
}

struct PostBusinessOwner: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let fullName: String
    let username: String
    let avatar: String?
    let profession: String
    let ratingsAverage: Float
    let ratingsCount: Int

    var avatarURL: URL? { avatar.flatMap(URL.init(string:)) }
}

struct PostEmployee: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let fullName: String
    let username: String
    let avatar: String?
    let profession: String
    let ratingsAverage: Float
    let ratingsCount: Int

    var avatarURL: URL? { avatar.flatMap(URL.init(string:)) }
}

struct PostBusinessLocation: Equatable, Hashable, Sendable {
    let address: String
    let formattedAddress: String
    let coordinates: BusinessCoordinates
    let mapUrl: String?
    let placeId: String
}

struct PostReview: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let review: String?
    let rating: Int
    let createdAt: String
}

struct PostServiceDomain: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let name: String
}

struct PostProduct: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let name: String
    let description: String?
    let duration: Int
    let price: Decimal
    let priceWithDiscount: Decimal
    let discount: Decimal
    let currency: PostProductCurrency
}

struct PostProductCurrency: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let name: String
}

struct UserPostActions: Equatable, Hashable, Sendable {
    let isLiked: Bool
    let isBookmarked: Bool
    let isReposted: Bool
}

struct PostMediaFile: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let url: String?
    let type: String
    let thumbnailUrl: String?
    let duration: Float?
    let postId: Int
    let orderIndex: Int
    let customCoverUrl: String?
    let status: String
    let readyToStream: Bool
}

struct Hashtag: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let name: String
    let createdAt: String
    let updatedAt: String
}

struct PostCounters: Equatable, Hashable, Sendable {
    let commentCount: Int
    let likeCount: Int
    let bookmarkCount: Int
    let repostCount: Int
    let shareCount: Int
    let bookingsCount: Int
    let viewsCount: Int
}

extension Post {
    func copy(
        id: Int? = nil,
        description: String?? = nil,
        user: PostUser? = nil,
        businessOwner: PostBusinessOwner? = nil,
        employee: PostEmployee?? = nil,
        businessLocation: PostBusinessLocation?? = nil,
        counters: PostCounters? = nil,
        userActions: UserPostActions? = nil,
        mediaFiles: [PostMediaFile]? = nil,
        hashtags: [Hashtag]?? = nil,
        isVideoReview: Bool? = nil,
        isOwnPost: Bool? = nil,
        businessId: Int?? = nil,
        review: PostReview?? = nil,
        serviceDomain: PostServiceDomain?? = nil,
        createdAt: String? = nil
    ) -> Post {
        Post(
            id: id ?? self.id,
            description: description ?? self.description,
            user: user ?? self.user,
            businessOwner: businessOwner ?? self.businessOwner,
            employee: employee ?? self.employee,
            businessLocation: businessLocation ?? self.businessLocation,
            counters: counters ?? self.counters,
            userActions: userActions ?? self.userActions,
            mediaFiles: mediaFiles ?? self.mediaFiles,
            hashtags: hashtags ?? self.hashtags,
            isVideoReview: isVideoReview ?? self.isVideoReview,
            isOwnPost: isOwnPost ?? self.isOwnPost,
            businessId: businessId ?? self.businessId,
            review: review ?? self.review,
            serviceDomain: serviceDomain ?? self.serviceDomain,
            createdAt: createdAt ?? self.createdAt
        )
    }
}

extension UserPostActions {
    func copy(
        isLiked: Bool? = nil,
        isBookmarked: Bool? = nil,
        isReposted: Bool? = nil
    ) -> UserPostActions {
        UserPostActions(
            isLiked: isLiked ?? self.isLiked,
            isBookmarked: isBookmarked ?? self.isBookmarked,
            isReposted: isReposted ?? self.isReposted
        )
    }
}

extension PostCounters {
    func copy(
        commentCount: Int? = nil,
        likeCount: Int? = nil,
        bookmarkCount: Int? = nil,
        repostCount: Int? = nil,
        shareCount: Int? = nil,
        bookingsCount: Int? = nil,
        viewsCount: Int? = nil
    ) -> PostCounters {
        PostCounters(
            commentCount: commentCount ?? self.commentCount,
            likeCount: likeCount ?? self.likeCount,
            bookmarkCount: bookmarkCount ?? self.bookmarkCount,
            repostCount: repostCount ?? self.repostCount,
            shareCount: shareCount ?? self.shareCount,
            bookingsCount: bookingsCount ?? self.bookingsCount,
            viewsCount: viewsCount ?? self.viewsCount
        )
    }
}
