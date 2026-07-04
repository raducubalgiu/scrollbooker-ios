//
//  RegistrationStepEnum.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 03.09.2025.
//

import Foundation

enum RegistrationStepEnum: String, CaseIterable, Equatable, Hashable, Sendable, Codable {
    // Shared
    case collectUserEmailValidation = "collect_user_email_validation"
    case collectUserUsername = "collect_user_username"
    case collectUserPhoneHumber = "collect_user_phone_number"

    // Client
    case collectClientBirthdate = "collect_client_birthdate"
    case collectClientGender = "collect_client_gender"
    case collectClientLocationPermission = "collect_client_location_permission"

    // Business
    case collectBusiness = "collect_business"
    case collectBusinessServices = "collect_business_services"
    case collectBusinessSchedules = "collect_business_schedules"
    case collectBusinessHasEmployees = "collect_business_has_employees"
    case collectBusinessCurrencies = "collect_business_currencies"
    case collectBusinessValidation = "collect_business_validation"

    // Înlocuiește 'fromKeyOrNull' din Kotlin
    static func fromKeyOrNull(_ key: String?) -> RegistrationStepEnum? {
        guard let key = key else { return nil }
        return RegistrationStepEnum(rawValue: key)
    }
}
