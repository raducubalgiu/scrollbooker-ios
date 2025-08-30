//
//  notificationData.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 30.08.2025.
//

import Foundation

let dummyNotifications: [Notification] = [
    Notification(
        id: 1,
        type: NotificationType(rawValue: "follow")!,
        senderId: 1,
        receiverId: 2,
        data: nil,
        message: "",
        isRead: true,
        isDeleted: false,
        sender: UserMini(
            id: 1,
            fullName: "Raducu Balgiu",
            username: "radu_balgiu",
            avatar: "",
            isFollow: false,
            profession: "Creator",
            ratingsAverage: 4.5,
            isBusinessOrEmployee: false
        )
    ),
    Notification(
        id: 2,
        type: NotificationType(rawValue: "follow")!,
        senderId: 1,
        receiverId: 2,
        data: nil,
        message: "",
        isRead: true,
        isDeleted: false,
        sender: UserMini(
            id: 2,
            fullName: "George Dragomir",
            username: "george_dragomir",
            avatar: "",
            isFollow: false,
            profession: "Creator",
            ratingsAverage: 4.5,
            isBusinessOrEmployee: false
        )
    ),
    Notification(
        id: 3,
        type: NotificationType(rawValue: "like")!,
        senderId: 1,
        receiverId: 2,
        data: nil,
        message: "",
        isRead: true,
        isDeleted: false,
        sender: UserMini(
            id: 3,
            fullName: "Gigi Corsicanu",
            username: "gigi_corsicanu",
            avatar: "",
            isFollow: false,
            profession: "Creator",
            ratingsAverage: 4.5,
            isBusinessOrEmployee: false
        )
    ),
    Notification(
        id: 4,
        type: NotificationType(rawValue: "employment_request")!,
        senderId: 1,
        receiverId: 2,
        data: nil,
        message: "",
        isRead: true,
        isDeleted: false,
        sender: UserMini(
            id: 4,
            fullName: "Frizeria Figaro",
            username: "frizeria_figaro",
            avatar: "",
            isFollow: false,
            profession: "Frizerie",
            ratingsAverage: 4.5,
            isBusinessOrEmployee: false
        )
    ),
    Notification(
        id: 5,
        type: NotificationType(rawValue: "follow")!,
        senderId: 1,
        receiverId: 2,
        data: nil,
        message: "",
        isRead: true,
        isDeleted: false,
        sender: UserMini(
            id: 5,
            fullName: "Frizeria Figaro",
            username: "frizeria_bucuresti",
            avatar: "",
            isFollow: false,
            profession: "Creator",
            ratingsAverage: 4.5,
            isBusinessOrEmployee: false
        )
    ),
    Notification(
        id: 6,
        type: NotificationType(rawValue: "follow")!,
        senderId: 1,
        receiverId: 2,
        data: nil,
        message: "",
        isRead: true,
        isDeleted: false,
        sender: UserMini(
            id: 5,
            fullName: "Johny Bravo",
            username: "johny_bravo",
            avatar: "",
            isFollow: false,
            profession: "Creator",
            ratingsAverage: 4.5,
            isBusinessOrEmployee: false
        )
    ),
]
