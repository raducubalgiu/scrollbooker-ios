//
//  AccountInfoRepository.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.10.2026.
//

protocol AccountInfoRepository: Sendable {
    func getAccountInfo() async throws -> AccountInfo
    func sendPhoneVerificationCode(phone: String) async throws -> String
    func verifyPrivatePhoneNumber(phone: String, code: String) async throws -> PrivatePhoneVerificationResult
}
