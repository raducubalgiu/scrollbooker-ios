//
//  ProfessionRepository.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

protocol ProfessionRepository: Sendable {
    func getProfessionsBybusinessType(businessTypeId: Int) async throws -> [Profession]
}
