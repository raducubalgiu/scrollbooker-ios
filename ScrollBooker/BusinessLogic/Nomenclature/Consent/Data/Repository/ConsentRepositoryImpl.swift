//
//  ConsentRepositoryImpl.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

final class ConsentRepositoryImpl: ConsentRepository {
    private let api: ConsentApiService
    
    init(api: ConsentApiService) {
        self.api = api
    }
    
    func getConsentbyName(consentName: ConsentEnum) async throws -> Consent {
        let dtoResponse = try await api.getConsentByName(consentName: consentName)
        
        return Consent(dto: dtoResponse)
    }
}
