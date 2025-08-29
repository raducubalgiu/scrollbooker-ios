//
//  socialLists.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 29.08.2025.
//

import Foundation

let userFollowers: [UserMini] = [
    UserMini(
        id: 1,
        fullName: "Radu Balgiu",
        username: "radu_balgiu",
        avatar: "",
        isFollow: false,
        profession: "Creator",
        ratingsAverage: 4.5,
        isBusinessOrEmployee: false
    ),
    UserMini(
        id: 2,
        fullName: "Marin Radu",
        username: "marin_radu",
        avatar: "",
        isFollow: false,
        profession: "Stylist",
        ratingsAverage: 4.8,
        isBusinessOrEmployee: true
    ),
    UserMini(
        id: 3,
        fullName: "Gigi Corsicanu",
        username: "gigi.corsicanu",
        avatar: "",
        isFollow: true,
        profession: "Creator",
        ratingsAverage: 4.5,
        isBusinessOrEmployee: false
    ),
    UserMini(
        id: 4,
        fullName: "Trattoria Monza",
        username: "trattoria.monza",
        avatar: "",
        isFollow: false,
        profession: "Restaurant",
        ratingsAverage: 4.8,
        isBusinessOrEmployee: true
    ),
    UserMini(
        id: 5,
        fullName: "ITP Dristor",
        username: "@itp_dristor",
        avatar: "",
        isFollow: true,
        profession: "Statie ITP",
        ratingsAverage: 4.5,
        isBusinessOrEmployee: true
    ),
    UserMini(
        id: 6,
        fullName: "Georgel Ion",
        username: "georgel_ion",
        avatar: "",
        isFollow: false,
        profession: "Creator",
        ratingsAverage: 4.5,
        isBusinessOrEmployee: false
    ),
    UserMini(
        id: 7,
        fullName: "Gica Hagi",
        username: "gica_hagi",
        avatar: "",
        isFollow: false,
        profession: "Creator",
        ratingsAverage: 4.2,
        isBusinessOrEmployee: false
    ),
    UserMini(
        id: 8,
        fullName: "Ana Blandiana",
        username: "ana.blandiana",
        avatar: "",
        isFollow: false,
        profession: "Creator",
        ratingsAverage: 4.2,
        isBusinessOrEmployee: false
    ),
    UserMini(
        id: 9,
        fullName: "Frizeria Bucuresti",
        username: "frizeria_bucuresti",
        avatar: "",
        isFollow: false,
        profession: "Frizerie",
        ratingsAverage: 4.2,
        isBusinessOrEmployee: true
    ),
    UserMini(
        id: 10,
        fullName: "Cornel Dumitru",
        username: "cornel.dumitru",
        avatar: "",
        isFollow: false,
        profession: "Creator",
        ratingsAverage: 4.2,
        isBusinessOrEmployee: false
    ),
    UserMini(
        id: 11,
        fullName: "Radu Cristian",
        username: "radu_cristian",
        avatar: "",
        isFollow: false,
        profession: "Creator",
        ratingsAverage: 4.5,
        isBusinessOrEmployee: false
    ),
]

let userFollowings: [UserMini] = [
    UserMini(
        id: 4,
        fullName: "Trattoria Monza",
        username: "trattoria.monza",
        avatar: "",
        isFollow: false,
        profession: "Restaurant",
        ratingsAverage: 4.8,
        isBusinessOrEmployee: true
    ),
    UserMini(
        id: 5,
        fullName: "ITP Dristor",
        username: "@itp_dristor",
        avatar: "",
        isFollow: true,
        profession: "Statie ITP",
        ratingsAverage: 4.5,
        isBusinessOrEmployee: true
    ),
    UserMini(
        id: 1,
        fullName: "Radu Balgiu",
        username: "radu_balgiu",
        avatar: "",
        isFollow: false,
        profession: "Creator",
        ratingsAverage: 4.5,
        isBusinessOrEmployee: false
    ),
    UserMini(
        id: 2,
        fullName: "Marin Radu",
        username: "marin_radu",
        avatar: "",
        isFollow: false,
        profession: "Stylist",
        ratingsAverage: 4.8,
        isBusinessOrEmployee: true
    ),
    UserMini(
        id: 3,
        fullName: "Gigi Corsicanu",
        username: "gigi.corsicanu",
        avatar: "",
        isFollow: true,
        profession: "Creator",
        ratingsAverage: 4.5,
        isBusinessOrEmployee: false
    ),
    UserMini(
        id: 8,
        fullName: "Ana Blandiana",
        username: "ana.blandiana",
        avatar: "",
        isFollow: false,
        profession: "Creator",
        ratingsAverage: 4.2,
        isBusinessOrEmployee: false
    ),
    UserMini(
        id: 9,
        fullName: "Frizeria Bucuresti",
        username: "frizeria_bucuresti",
        avatar: "",
        isFollow: false,
        profession: "Frizerie",
        ratingsAverage: 4.2,
        isBusinessOrEmployee: true
    ),
    UserMini(
        id: 10,
        fullName: "Cornel Dumitru",
        username: "cornel.dumitru",
        avatar: "",
        isFollow: false,
        profession: "Creator",
        ratingsAverage: 4.2,
        isBusinessOrEmployee: false
    ),
    UserMini(
        id: 6,
        fullName: "Georgel Ion",
        username: "georgel_ion",
        avatar: "",
        isFollow: false,
        profession: "Creator",
        ratingsAverage: 4.5,
        isBusinessOrEmployee: false
    ),
    UserMini(
        id: 7,
        fullName: "Gica Hagi",
        username: "gica_hagi",
        avatar: "",
        isFollow: false,
        profession: "Creator",
        ratingsAverage: 4.2,
        isBusinessOrEmployee: false
    ),
    UserMini(
        id: 11,
        fullName: "Radu Cristian",
        username: "radu_cristian",
        avatar: "",
        isFollow: false,
        profession: "Creator",
        ratingsAverage: 4.5,
        isBusinessOrEmployee: false
    ),
]

let userReviews: [Review] = [
    Review(
        id: 1,
        rating: 5,
        review: "Am fost foarte multumit de aceasta experienta.",
        customer: ReviewCustomer(id: 1, username: "cristiano", fullName: "Cristiano Ronaldo", avatar: ""),
        service: ReviewService(id: 1, name: "Tuns"),
        product: ReviewProduct(id: 1, name: "Tuns special"),
        likeCount: 0,
        isLiked: false,
        isLikedByAuthor: false,
        createdAt: "2025-08-29T14:10:29.465384Z"
    ),
    Review(
        id: 2,
        rating: 5,
        review: "Exceptional. M-a tuns foarte bine!",
        customer: ReviewCustomer(id: 1, username: "radu_balgiu", fullName: "Raducu Balgiu", avatar: ""),
        service: ReviewService(id: 1, name: "Tuns"),
        product: ReviewProduct(id: 2, name: "Tuns scurt"),
        likeCount: 0,
        isLiked: true,
        isLikedByAuthor: false,
        createdAt: "2025-08-29T18:10:29.465384Z"
    ),
    Review(
        id: 3,
        rating: 3,
        review: "Nu prea mi-a placut. A intarziat 30 de minute si nu am putut sa ajung la birou in timp util",
        customer: ReviewCustomer(id: 1, username: "gigi_corsicanu", fullName: "Gigi Corsicanu", avatar: ""),
        service: ReviewService(id: 1, name: "Tuns"),
        product: ReviewProduct(id: 2, name: "Tuns special"),
        likeCount: 0,
        isLiked: true,
        isLikedByAuthor: false,
        createdAt: "2025-08-29T10:30:29.465384Z"
    ),
    Review(
        id: 4,
        rating: 4,
        review: "Singurul lucru care nu mi-a placut a fost locatia. Nu era foarte ingrijita",
        customer: ReviewCustomer(id: 1, username: "georgel_cristian", fullName: "Georgel Cristian", avatar: ""),
        service: ReviewService(id: 1, name: "Pensat"),
        product: ReviewProduct(id: 3, name: "Pensat"),
        likeCount: 0,
        isLiked: false,
        isLikedByAuthor: false,
        createdAt: "2025-08-29T16:30:29.465384Z"
    ),
    Review(
        id: 5,
        rating: 5,
        review: "Exceptional. Am gasit tunsoarea perfecta",
        customer: ReviewCustomer(id: 1, username: "radu_cristian", fullName: "Radu Cristian", avatar: ""),
        service: ReviewService(id: 1, name: "Tuns"),
        product: ReviewProduct(id: 3, name: "Tuns special"),
        likeCount: 0,
        isLiked: false,
        isLikedByAuthor: true,
        createdAt: "2025-08-29T16:30:29.465384Z"
    )
]
