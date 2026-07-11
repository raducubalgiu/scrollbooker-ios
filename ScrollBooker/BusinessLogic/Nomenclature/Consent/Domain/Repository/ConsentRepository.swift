//
//  ConsentRepository.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

protocol ConsentRepository: Sendable {
    func getConsentbyName(consentName: ConsentEnum) async throws -> Consent
}
