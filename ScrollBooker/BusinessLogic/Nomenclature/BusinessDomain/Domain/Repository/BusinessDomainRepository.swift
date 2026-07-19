//
//  BusinessDomainRepository.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 19.07.2026.
//

protocol BusinessDomainRepository: Sendable {
    func getAllBusinessDomains() async throws -> [BusinessDomain]
}
