//
//  SearchRepository.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

protocol SearchRepository: Sendable {
    func searchUsers(query: String, roleClient: Bool?) async throws -> [SearchUser]
}
