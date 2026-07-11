//
//  ConsentEnum.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

import Foundation

enum ConsentEnum: String, Codable, Sendable, CaseIterable {
    case employmentRequestsInitiation = "EMPLOYMENT_REQUESTS_INITIATION"
    case employmentRequestsAcceptance = "EMPLOYMENT_REQUESTS_ACCEPTANCE"
    case employmentRequestsResignationByBusiness = "EMPLOYMENT_REQUESTS_RESIGNATION_BY_BUSINESS"
    case employmentRequestsResignationByEmployee = "EMPLOYMENT_REQUESTS_RESIGNATION_BY_EMPLOYEE"

    static func fromKey(_ key: String) -> ConsentEnum? {
        return ConsentEnum(rawValue: key)
    }
    
    static func fromKeys(_ keys: [String]) -> [ConsentEnum] {
        return keys.compactMap { ConsentEnum(rawValue: $0) }
    }
}
