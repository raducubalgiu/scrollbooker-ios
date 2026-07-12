//
//  ProfileState.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 12.07.2026.
//

enum ProfileState: Equatable {
    case idle
    case loading
    case success(UserProfile)
    case error(String)
}
