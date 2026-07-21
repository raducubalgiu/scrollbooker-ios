//
//  UserSocial.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.07.2026.
//

struct UserSocial: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let fullName: String
    let username: String
    let profession: String
    let avatar: String?
    let ratingsAverage: Double
    let isFollow: Bool
    let isBusinessOrEmployee: Bool
    
    func copy(
        id: Int? = nil,
        fullName: String? = nil,
        username: String? = nil,
        profession: String? = nil,
        avatar: String? = nil,
        ratingsAverage: Double? = nil,
        isFollow: Bool? = nil,
        isBusinessOrEmployee: Bool? = nil
    ) -> UserSocial {
        UserSocial(
            id: id ?? self.id,
            fullName: fullName ?? self.fullName,
            username: username ?? self.username,
            profession: profession ?? self.profession,
            avatar: avatar ?? self.avatar,
            ratingsAverage: ratingsAverage ?? self.ratingsAverage,
            isFollow: isFollow ?? self.isFollow,
            isBusinessOrEmployee: isBusinessOrEmployee ?? self.isBusinessOrEmployee
        )
    }
}
