//
//  dummyBookNowData.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 03.09.2025.
//

let dummyBookNowPosts: [Post] = [
    Post(
        id: 1,
        description: "Transforma-ti look-ul cu o tunsoare preciza, adaptata formei fetei si stilului tau.",
        user: UserMini(
            id: 13,
            fullName: "Radu Ion",
            username: "radu_ion",
            avatar: "",
            isFollow: false,
            profession: "Stylist",
            ratingsAverage: 4.5,
            isBusinessOrEmployee: true
        ),
        product: nil,
        userAction: UserPostActions(
            isLiked: true,
            isBookmarked: true,
            isReposted: false
        ),
        mediaFiles: [
            PostMediaFile(
                id: 1,
                url: "https://media.scrollbooker.ro/video-post-6.mp4",
                type: "video",
                thumbnailUrl: "",
                duration: 10,
                postId: 1,
                orderIndex: 0
            )
        ],
        counters: PostCounters(
            commentCount: 15,
            likeCount: 50,
            bookmarkCount: 10,
            shareCount: 2,
            bookingsCount: 0
        ),
        mentions: [],
        hashtags: [],
        bookable: false,
        businessId: 1,
        instantBooking: true,
        lastMinute: LastMinute(
            isLastMinute: false,
            lastMinuteEnd: "",
            hasFixedSlots: false,
            fixedSlots: []),
        createdAt: "2025-07-31T07:55:01.116776Z"
    ),
    Post(
        id: 2,
        description: "Cui se adresează cursurile de dans?\nCursurile de dans pentru copii organizate de Viva Sport Club se adresează tuturor copiilor care au peste 4 ani.",
        user: UserMini(
            id: 2,
            fullName: "Salsa Factory",
            username: "salsa_factory",
            avatar: "",
            isFollow: false,
            profession: "Scoala de dans",
            ratingsAverage: 4.5,
            isBusinessOrEmployee: true
        ),
        product: nil,
        userAction: UserPostActions(
            isLiked: true,
            isBookmarked: true,
            isReposted: false
        ),
        mediaFiles: [
            PostMediaFile(
                id: 2,
                url: "https://media.scrollbooker.ro/frizerie-2.mov",
                type: "video",
                thumbnailUrl: "",
                duration: 10,
                postId: 2,
                orderIndex: 0
            )
        ],
        counters: PostCounters(
            commentCount: 1210,
            likeCount: 10000,
            bookmarkCount: 1000,
            shareCount: 20,
            bookingsCount: 0
        ),
        mentions: [],
        hashtags: [],
        bookable: false,
        businessId: 2,
        instantBooking: true,
        lastMinute: LastMinute(
            isLastMinute: false,
            lastMinuteEnd: "",
            hasFixedSlots: false,
            fixedSlots: []),
        createdAt: "2025-07-31T07:55:01.116776Z"
    ),
    Post(
        id: 3,
        description: nil,
        user: UserMini(
            id: 3,
            fullName: "Radu Ion",
            username: "radu_ion",
            avatar: "",
            isFollow: false,
            profession: "Stylist",
            ratingsAverage: 4.5,
            isBusinessOrEmployee: true
        ),
        product: nil,
        userAction: UserPostActions(
            isLiked: true,
            isBookmarked: true,
            isReposted: false
        ),
        mediaFiles: [
            PostMediaFile(
                id: 3,
                url: "https://media.scrollbooker.ro/frizerie-1.mov",
                type: "video",
                thumbnailUrl: "",
                duration: 10,
                postId: 3,
                orderIndex: 0
            )
        ],
        counters: PostCounters(
            commentCount: 110,
            likeCount: 10,
            bookmarkCount: 100,
            shareCount: 20,
            bookingsCount: 0
        ),
        mentions: [],
        hashtags: [],
        bookable: false,
        businessId: 3,
        instantBooking: true,
        lastMinute: LastMinute(
            isLastMinute: true,
            lastMinuteEnd: "",
            hasFixedSlots: false,
            fixedSlots: []),
        createdAt: "2025-07-31T07:55:01.116776Z"
    )
]
