//
//  userProfileData.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 31.08.2025.
//

let dummyUserProfile: UserProfile = UserProfile(
    id: 13,
    username: "radu_ion",
    fullName: "Radu Ion",
    avatar: "",
    gender: "other",
    bio: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been.",
    businessId: 1,
    businessTypeId: 1,
    counters: UserCounters(
        userId: 13,
        followingsCount: 123,
        followersCount: 10200,
        productsCount: 5,
        postsCount: 10,
        ratingsCount: 10,
        ratingsAverage: 5
    ),
    profession: "Stylist",
    openingHours: OpeningHours(
        openNow: false,
        closingTime: nil,
        nextOpenDay: "Monday",
        nextOpenTime: "09:00"
    ),
    isFollow: false,
    businessOwner: BusinessOwner(
        id: 2,
        fullName: "Frizeria Figaro",
        username: "frizeria_figaro",
        avatar: "",
        isFollow: false
    ),
    isOwnProfile: true,
    isBusinessOrEmployee: true,
    distanceKm: 2.4,
    address: ""
)
