//
//  UserProfileUpdateMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 12.07.2026.
//

import Foundation

extension UserProfileUpdate {
    init(dto: UserProfileUpdateDto) {
        self.id = dto.id
        self.fullName = dto.fullname
        self.username = dto.username
        self.avatarURL = dto.avatar
        self.bio = dto.bio
        self.gender = dto.gender
        self.website = dto.website
        self.publicEmail = dto.publicEmail
        
        if let dateString = dto.dateOfBirth {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withFullDate]
            self.dateOfBirth = formatter.date(from: dateString)
        } else {
            self.dateOfBirth = nil
        }
    }
}
