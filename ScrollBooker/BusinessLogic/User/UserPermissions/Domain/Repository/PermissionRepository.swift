//
//  PermissionRepository.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

protocol PermissionRepository: Sendable {
    func getUserPermissions() async throws -> [Permission]
}
