//
//  UserProfileRepository.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 07.07.2026.
//

protocol UserProfileRepository: Sendable {
    func getUserProfile(username: String) async throws -> UserProfile
}
