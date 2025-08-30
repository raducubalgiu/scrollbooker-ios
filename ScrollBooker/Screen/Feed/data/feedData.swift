//
//  feedData.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 30.08.2025.
//

let recommendedBusinesses: [RecommendedBusiness] = [
    RecommendedBusiness(
        id: 1,
        user: UserMini(
            id: 1,
            fullName: "Trattoria Monza",
            username: "tratoria_monza",
            avatar: "",
            isFollow: false,
            profession: "Restaurant",
            ratingsAverage: 4.5,
            isBusinessOrEmployee: true
        ),
        distance: 1.2,
        isOpen: true
    ),
    RecommendedBusiness(
        id: 2,
        user: UserMini(
            id: 2,
            fullName: "ITP Dristor",
            username: "itp_dristor",
            avatar: "",
            isFollow: false,
            profession: "Statie ITP",
            ratingsAverage: 4.8,
            isBusinessOrEmployee: true
        ),
        distance: 1.4,
        isOpen: true
    )
]
