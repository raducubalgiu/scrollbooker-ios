//
//  AccountInfoRepository.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.10.2026.
//

protocol AccountInfoRepository: Sendable {
    func getAccountInfo() async throws -> AccountInfo
    func sendPhoneVerificationCode(phone: String) async throws -> String
    func verifyPhoneNumber(phone: String, code: String) async throws -> PhoneVerificationResult
}
