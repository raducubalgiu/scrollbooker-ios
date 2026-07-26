//
//  UserProfileAboutDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 26.07.2026.
//

struct UserProfileAbout: Identifiable, Hashable, Sendable {
    var id: Int { owner.id }
    
    let description: String?
    let schedules: [Schedule]
    let location: BusinessLocation
    let owner: UserProfileAboutOwner
    let businessMedia: [BusinessMediaFile]
}

struct UserProfileAboutOwner: Identifiable, Hashable, Sendable{
    let id: Int
    let fullName: String
    let username: String
    let profession: String
    let avatar: String?
    let ratingsAverage: Float
}
